import 'package:flutter/foundation.dart';
import 'dart:html' as html;

enum DeviceType { mobile, tablet, desktop }

class DeviceDetector {
  static DeviceType? _cachedType;

  static void init() {
    _cachedType = null;
  }

  static DeviceType get type {
    if (_cachedType != null) return _cachedType!;
    if (!kIsWeb) return DeviceType.desktop;

    final userAgent = html.window.navigator.userAgent.toLowerCase();
    if (userAgent.contains('mobile')) {
      _cachedType = DeviceType.mobile;
    } else if (userAgent.contains('tablet')) {
      _cachedType = DeviceType.tablet;
    } else {
      _cachedType = DeviceType.desktop;
    }
    return _cachedType!;
  }

  static bool get isMobile => type == DeviceType.mobile;
  static bool get isDesktop => type == DeviceType.desktop;
  static bool get isTablet => type == DeviceType.tablet;
}
