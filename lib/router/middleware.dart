import 'package:flutter/material.dart';

typedef RouteGuard = Future<bool> Function(BuildContext context, String route);
typedef Middleware = Future<void> Function(BuildContext context, String route);

class RouterMiddleware {
  static List<RouteGuard> guards = [];
  static List<Middleware> preProcessors = [];

  static void addGuard(RouteGuard guard) => guards.add(guard);
  static void addMiddleware(Middleware middleware) =>
      preProcessors.add(middleware);
}
