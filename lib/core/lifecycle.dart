import 'dart:developer';

import 'package:flutter/widgets.dart';

abstract class AppLifecycleHook {
  void onStateChanged(AppLifecycleState state);
}

class LoggerHook implements AppLifecycleHook {
  @override
  void onStateChanged(AppLifecycleState state) {
    log('App lifecycle: $state');
  }
}
