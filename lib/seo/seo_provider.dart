import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'seo_controller.dart';

class SeoControllerProvider extends StatefulWidget {
  final SeoController controller;
  final Widget child;

  const SeoControllerProvider({
    super.key,
    required this.controller,
    required this.child,
  });

  static SeoController of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_SeoInherited>();
    if (provider == null) {
      throw Exception('SeoControllerProvider not found in tree. Did you wrap your app with it?');
    }
    return provider.controller;
  }

  @override
  State<SeoControllerProvider> createState() => _SeoControllerProviderState();
}

class _SeoControllerProviderState extends State<SeoControllerProvider> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(SeoControllerProvider oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (!mounted) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _SeoInherited(
      controller: widget.controller,
      child: widget.child,
    );
  }
}

class _SeoInherited extends InheritedWidget {
  final SeoController controller;

  const _SeoInherited({
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(_SeoInherited oldWidget) => false;
}
