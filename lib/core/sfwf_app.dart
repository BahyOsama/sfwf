import 'package:flutter/material.dart';
import 'package:sfwf/seo/seo_controller.dart';
import 'package:sfwf/seo/seo_provider.dart'; // إضافة المستورد الجديد
import 'package:sfwf/core/config.dart';
import 'package:sfwf/router/smart_router.dart';
import 'lifecycle.dart';

class SFWFApp extends StatefulWidget {
  final SFWFConfig config;
  final Map<String, WidgetBuilder> routes;
  final List<AppLifecycleHook>? lifecycleHooks;

  const SFWFApp({
    super.key,
    required this.config,
    required this.routes,
    this.lifecycleHooks,
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
    _router = SmartRouter(routes: widget.routes, config: widget.config);
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
    return SeoControllerProvider(
      controller: _seoController,
      child: MaterialApp.router(
        title: widget.config.appName,
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeParser,
        backButtonDispatcher: _router.backDispatcher,
        theme: ThemeData(useMaterial3: true),
      ),
    );
  }
}
