import 'package:flutter/material.dart';

/// Utilities for lazy-loading widgets and async data.
class LazyLoader {
  /// Executes [loader] after an optional [delay].
  static Future<T> loadAsync<T>(Future<T> Function() loader,
      {Duration delay = Duration.zero}) async {
    if (delay > Duration.zero) await Future.delayed(delay);
    return loader();
  }

  /// Returns a [FutureBuilder] that shows [placeholder] while [builder] resolves.
  static Widget lazyWidget(Future<Widget> Function() builder,
      {Widget? placeholder}) {
    return FutureBuilder<Widget>(
      future: builder(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ??
              const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          return snapshot.data!;
        }
        return placeholder ?? const SizedBox.shrink();
      },
    );
  }
}
