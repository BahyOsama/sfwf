import 'package:flutter/material.dart';

/// Abstract interface for state management with change notification.
abstract class StateBridge<T> {
  /// The value notifier that exposes state changes to listeners.
  ValueNotifier<T> get notifier;

  /// Updates the current state to [newState] and notifies listeners.
  void update(T newState);

  /// The current state value.
  T get state;
}

/// A concrete implementation of [StateBridge] backed by a [ValueNotifier].
class SimpleStateBridge<T> extends StateBridge<T> {
  final ValueNotifier<T> _notifier;

  /// Creates a [SimpleStateBridge] with the given [initialState].
  SimpleStateBridge(T initialState) : _notifier = ValueNotifier<T>(initialState);

  /// The underlying [ValueNotifier] exposing state changes.
  @override
  ValueNotifier<T> get notifier => _notifier;

  /// The current state value.
  @override
  T get state => _notifier.value;

  /// Updates the state and triggers change notification.
  @override
  void update(T newState) {
    _notifier.value = newState;
}
}
