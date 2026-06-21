import 'package:flutter/material.dart';

class AuthGuard {
  static bool _isAuthenticated = false;

  static void setAuthenticated(bool value) {
    _isAuthenticated = value;
  }

  static Future<bool> isAuthenticated(BuildContext context, String route) async {
    return _isAuthenticated;
  }
}
