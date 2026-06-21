import 'package:flutter/material.dart';
import 'device_detector.dart';

/// A widget that adapts its rendering based on the detected device type.
class AdaptiveBuilder extends StatelessWidget {
  /// Callback that builds a widget given the [BuildContext] and [DeviceType].
  final Widget Function(BuildContext, DeviceType) builder;

  /// Creates an [AdaptiveBuilder] with the given [builder] callback.
  const AdaptiveBuilder({super.key, required this.builder});

  /// Builds the widget tree by delegating to [builder] with the current device type.
  @override
  Widget build(BuildContext context) {
    return builder(context, DeviceDetector.type);
  }
}
