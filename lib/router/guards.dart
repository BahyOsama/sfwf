import 'package:flutter/material.dart';

/// A simple authentication guard that controls route access.
class AuthGuard {
  static bool _isAuthenticated = false;

  /// Updates the authentication state.
  static void setAuthenticated(bool value) {
    _isAuthenticated = value;
  }

  /// Returns whether the user is authenticated for the given route.
  static Future<bool> isAuthenticated(BuildContext context, String route) async {
    return _isAuthenticated;
  }
}
