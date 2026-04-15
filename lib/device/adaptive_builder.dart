import 'package:flutter/material.dart';
import 'device_detector.dart';

class AdaptiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, DeviceType) builder;

  const AdaptiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, DeviceDetector.type);
  }
}
