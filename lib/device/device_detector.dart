import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

/// Categorizes the user's device form factor.
enum DeviceType {
  /// A mobile phone-sized device.
  mobile,
  /// A tablet-sized device.
  tablet,
  /// A desktop or laptop computer.
  desktop,
}

/// Detects the current device type via user-agent parsing on web.
class DeviceDetector {
  static DeviceType? _cachedType;

  /// Resets the cached device type so it is re-evaluated.
  static void init() {
    _cachedType = null;
  }

  /// Detects and caches the current [DeviceType].
  static DeviceType get type {
    if (_cachedType != null) return _cachedType!;
    if (!kIsWeb) return DeviceType.desktop;

    try {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      if (userAgent.contains('mobile')) {
        _cachedType = DeviceType.mobile;
      } else if (userAgent.contains('tablet')) {
        _cachedType = DeviceType.tablet;
      } else {
        _cachedType = DeviceType.desktop;
      }
    } catch (_) {
      _cachedType = DeviceType.desktop;
    }
    return _cachedType!;
  }

  /// Whether the current device is a mobile phone.
  static bool get isMobile => type == DeviceType.mobile;

  /// Whether the current device is a desktop or laptop.
  static bool get isDesktop => type == DeviceType.desktop;

  /// Whether the current device is a tablet.
  static bool get isTablet => type == DeviceType.tablet;
}
