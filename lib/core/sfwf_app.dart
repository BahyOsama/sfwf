import 'package:flutter/material.dart';
import 'package:sfwf/seo/seo_controller.dart';
import 'package:sfwf/seo/seo_provider.dart';
import 'package:sfwf/core/config.dart';
import 'package:sfwf/router/smart_router.dart';
import 'package:sfwf/router/route_definition.dart';
import 'lifecycle.dart';

class SFWFApp extends StatefulWidget {
  final SFWFConfig config;
  final Map<String, WidgetBuilder> routes;
  final List<AppLifecycleHook>? lifecycleHooks;
  final List<RouteDefinition>? routeDefinitions;
  final ThemeData? theme;
  final WidgetBuilder? notFoundBuilder;
  final Map<String, RouteTransitionsBuilder>? customTransitions;
  final Widget Function(Widget child)? appWrapper;

  const SFWFApp({
    super.key,
    required this.config,
    required this.routes,
    this.lifecycleHooks,
    this.routeDefinitions,
    this.theme,
    this.notFoundBuilder,
    this.customTransitions,
    this.appWrapper,
  });

  @override
  State<SFWFApp> createState() => _SFWFAppState();
}

class _SFWFAppState extends State<SFWFApp> with WidgetsBindingObserver {
  late SeoController _seoController;
  late SmartRouter _router;

  @override
  void initState() {
    super.initState();
    _seoController = SeoController(config: widget.config);
    _router = SmartRouter(
      routes: widget.routes,
      config: widget.config,
      routeDefinitions: widget.routeDefinitions ?? [],
      notFoundBuilder: widget.notFoundBuilder,
      customTransitions: widget.customTransitions,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _seoController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    for (final hook in widget.lifecycleHooks ?? []) {
      hook.onStateChanged(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget app = MaterialApp.router(
      title: widget.config.appName,
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeParser,
      backButtonDispatcher: _router.backDispatcher,
      theme: widget.theme ?? ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );

    if (widget.appWrapper != null) {
      app = widget.appWrapper!(app);
    }

    return SeoControllerProvider(
      controller: _seoController,
      child: app,
    );
  }
}
