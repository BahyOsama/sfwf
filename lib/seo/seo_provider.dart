import 'package:flutter/material.dart';
import 'seo_controller.dart';

class SeoControllerProvider extends InheritedWidget {
  final SeoController controller;

  const SeoControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static SeoController of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<SeoControllerProvider>();
    if (provider == null) {
      throw Exception(
          'SeoControllerProvider not found in tree. Did you wrap your app with it?');
    }
    return provider.controller;
  }

  @override
  bool updateShouldNotify(SeoControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
