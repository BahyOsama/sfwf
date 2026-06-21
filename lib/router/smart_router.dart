import 'package:flutter/material.dart';
import 'package:sfwf/core/config.dart';
import 'package:sfwf/router/middleware.dart';
import 'package:sfwf/router/route_definition.dart';

class SmartRouter {
  final Map<String, WidgetBuilder> routes;
  final SFWFConfig config;
  final List<RouteDefinition> routeDefinitions;
  final WidgetBuilder? notFoundBuilder;
  final Map<String, RouteTransitionsBuilder>? customTransitions;
  late final RouterDelegate<RoutePath> routerDelegate;
  late final RouteInformationParser<RoutePath> routeParser;
  late final BackButtonDispatcher backDispatcher;

  SmartRouter({
    required this.routes,
    required this.config,
    this.routeDefinitions = const [],
    this.notFoundBuilder,
    this.customTransitions,
  }) {
    final router = _SmartRouterDelegate(
      routes, config, routeDefinitions,
      notFoundBuilder: notFoundBuilder,
      customTransitions: customTransitions,
    );
    routerDelegate = router;
    routeParser = _RouteParser();
    backDispatcher = RootBackButtonDispatcher();
  }
}

class RoutePath {
  final String path;
  final Map<String, String> params;
  final Map<String, String> queryParams;

  const RoutePath(this.path,
      {this.params = const {}, this.queryParams = const {}});

  @override
  String toString() => 'RoutePath($path, $params, $queryParams)';

  RoutePath copyWith({
    String? path,
    Map<String, String>? params,
    Map<String, String>? queryParams,
  }) {
    return RoutePath(
      path ?? this.path,
      params: params ?? this.params,
      queryParams: queryParams ?? this.queryParams,
    );
  }
}

class _SmartRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final Map<String, WidgetBuilder> routes;
  final SFWFConfig config;
  final List<RouteDefinition> routeDefinitions;
  final WidgetBuilder? notFoundBuilder;
  final Map<String, RouteTransitionsBuilder>? customTransitions;
  RoutePath? _currentPath;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  _SmartRouterDelegate(
    this.routes,
    this.config,
    this.routeDefinitions, {
    this.notFoundBuilder,
    this.customTransitions,
  }) : navigatorKey = GlobalKey<NavigatorState>();

  RouteMatch? _matchRoute(String path) {
    if (routes.containsKey(path)) {
      return RouteMatch(path, params: {});
    }

    for (final definition in routeDefinitions) {
      final pattern = definition.path;
      final patternSegments = pattern.split('/');
      final pathSegments = path.split('/');

      if (patternSegments.length != pathSegments.length) continue;

      bool match = true;
      final params = <String, String>{};

      for (int i = 0; i < patternSegments.length; i++) {
        if (patternSegments[i].startsWith(':')) {
          params[patternSegments[i].substring(1)] = pathSegments[i];
        } else if (patternSegments[i] != pathSegments[i]) {
          match = false;
          break;
        }
      }

      if (match) {
        return RouteMatch(definition.name ?? path, params: params);
      }
    }
    return null;
  }

  RouteTransitionsBuilder _getTransition(String? routeName) {
    if (routeName != null && customTransitions?.containsKey(routeName) == true) {
      return customTransitions![routeName]!;
    }
    return (context, animation, secondaryAnimation, child) => child;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        final match = _matchRoute(settings.name ?? '');
        final routeName = match?.name ?? settings.name;
        final builder = routes[routeName];

        if (builder == null) {
          if (notFoundBuilder != null) {
            return MaterialPageRoute(
              builder: (ctx) => notFoundBuilder!(ctx),
              settings: const RouteSettings(name: '/404'),
            );
          }
          return MaterialPageRoute(
            builder: (ctx) => _defaultNotFound(ctx),
            settings: const RouteSettings(name: '/404'),
          );
        }

        final params = match?.params ?? <String, String>{};
        final routeSettings = RouteSettings(
          name: routeName,
          arguments: settings.arguments ?? params,
        );

        return _buildPageRoute(
          settings: routeSettings,
          builder: (ctx) => _applyMiddlewares(builder(ctx), routeName ?? ''),
          transition: _getTransition(routeName),
        );
      },
    );
  }

  PageRoute _buildPageRoute({
    required RouteSettings settings,
    required WidgetBuilder builder,
    required RouteTransitionsBuilder transition,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (ctx, anim, secAnim) => builder(ctx),
      transitionsBuilder: transition,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
    );
  }

  Widget _applyMiddlewares(Widget page, String routeName) {
    return _GuardedWidget(
      page: page,
      routeName: routeName,
      guards: RouterMiddleware.guards,
      preProcessors: RouterMiddleware.preProcessors,
    );
  }

  Widget _defaultNotFound(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404 - Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Page Not Found', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text('The page "${_currentPath?.path ?? ''}" does not exist.'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => setNewRoutePath(const RoutePath('/')),
              icon: const Icon(Icons.home),
              label: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) async {
    final match = _matchRoute(path.path);
    if (match != null) {
      _currentPath = RoutePath(
        match.name,
        params: match.params,
        queryParams: path.queryParams,
      );
    } else if (routes.containsKey(path.path) || notFoundBuilder != null) {
      _currentPath = path;
    } else {
      _currentPath = path;
    }
    notifyListeners();
  }

  @override
  RoutePath get currentConfiguration =>
      _currentPath ?? const RoutePath('/');
}

class RouteMatch {
  final String name;
  final String? originalPath;
  final Map<String, String> params;

  const RouteMatch(this.name, {this.originalPath, this.params = const {}});
}

class _RouteParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(RouteInformation info) async {
    final uri = Uri.parse(info.uri.toString());
    return RoutePath(
      uri.path,
      queryParams: Map<String, String>.from(uri.queryParameters),
    );
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath path) {
    final uri = Uri.parse(path.path).replace(queryParameters: path.queryParams);
    return RouteInformation(uri: uri);
  }
}

class _GuardedWidget extends StatefulWidget {
  final Widget page;
  final String routeName;
  final List<RouteGuard> guards;
  final List<Middleware> preProcessors;

  const _GuardedWidget({
    required this.page,
    required this.routeName,
    required this.guards,
    required this.preProcessors,
  });

  @override
  State<_GuardedWidget> createState() => _GuardedWidgetState();
}

class _GuardedWidgetState extends State<_GuardedWidget> {
  bool _loading = true;
  bool _allowed = true;

  @override
  void initState() {
    super.initState();
    _execute();
  }

  Future<void> _execute() async {
    for (final pre in widget.preProcessors) {
      if (!mounted) return;
      await pre(context, widget.routeName);
    }

    for (final guard in widget.guards) {
      if (!mounted) return;
      final result = await guard(context, widget.routeName);
      if (!result) {
        setState(() => _allowed = false);
        return;
      }
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();
    if (!_allowed) return const SizedBox.shrink();
    return widget.page;
  }
}
