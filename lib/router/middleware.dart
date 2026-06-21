import 'package:flutter/material.dart';

/// Signature for a route guard that determines whether navigation is allowed.
typedef RouteGuard = Future<bool> Function(BuildContext context, String route);

/// Signature for middleware that processes a route before the page loads.
typedef Middleware = Future<void> Function(BuildContext context, String route);

/// Static registry for route guards and middleware processors.
class RouterMiddleware {
  /// Registered route guards.
  static List<RouteGuard> guards = [];

  /// Registered pre-processing middleware.
  static List<Middleware> preProcessors = [];

  /// Registers a new route guard.
  static void addGuard(RouteGuard guard) => guards.add(guard);

  /// Registers a new pre-processing middleware.
  static void addMiddleware(Middleware middleware) =>
      preProcessors.add(middleware);
}
