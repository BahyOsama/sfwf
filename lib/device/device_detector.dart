import 'package:flutter/foundation.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

class DeviceDetector {
  static DeviceType? _cachedType;

  static void init() {
    _cachedType = null;
  }

  static DeviceType get type {
    if (_cachedType != null) return _cachedType!;

    if (!kIsWeb) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
        case TargetPlatform.iOS:
          _cachedType = DeviceType.mobile;
        case TargetPlatform.macOS:
        case TargetPlatform.windows:
        case TargetPlatform.linux:
        case TargetPlatform.fuchsia:
          _cachedType = DeviceType.desktop;
      }
    } else {
      _cachedType = DeviceType.desktop;
    }

    return _cachedType!;
  }

  static bool get isMobile => type == DeviceType.mobile;
  static bool get isDesktop => type == DeviceType.desktop;
  static bool get isTablet => type == DeviceType.tablet;
}
