import 'package:flutter/material.dart';
import 'package:sfwf/core/config.dart';

class SmartRouter {
  final Map<String, WidgetBuilder> routes;
  final SFWFConfig config;
  late final RouterDelegate<RoutePath> routerDelegate;
  late final RouteInformationParser<RoutePath> routeParser;
  late final BackButtonDispatcher backDispatcher;

  SmartRouter({required this.routes, required this.config}) {
    final router = _SmartRouterDelegate(routes, config);
    routerDelegate = router;
    routeParser = _RouteParser();
    backDispatcher = RootBackButtonDispatcher();
  }
}

class RoutePath {
  final String path;
  final Map<String, String> params;
  const RoutePath(this.path, {this.params = const {}});

  @override
  String toString() => 'RoutePath($path, $params)';
}

class _SmartRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  final Map<String, WidgetBuilder> routes;
  final SFWFConfig config;
  RoutePath? _currentPath;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  _SmartRouterDelegate(this.routes, this.config)
      : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        final builder = routes[settings.name];
        if (builder == null) return null;
        return MaterialPageRoute(
          builder: (ctx) => _applyMiddlewares(builder(ctx), settings.name!),
          settings: settings,
        );
      },
    );
  }

  Widget _applyMiddlewares(Widget page, String routeName) {
    // Middleware execution (simplified)
    return page;
  }

  @override
  Future<void> setNewRoutePath(RoutePath path) async {
    _currentPath = path;
    notifyListeners();
  }

  @override
  RoutePath get currentConfiguration => _currentPath ?? const RoutePath('/');
}

class _RouteParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(RouteInformation info) async {
    final uri = Uri.parse(info.uri.toString());
    final path = uri.path;
    final params = Map<String, String>.from(uri.queryParameters);
    return RoutePath(path, params: params);
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath path) {
    final uri = Uri.parse(path.path).replace(queryParameters: path.params);
    return RouteInformation(uri: uri);
  }
}
