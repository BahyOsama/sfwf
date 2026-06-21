import 'package:flutter/material.dart';

abstract class StateBridge<T> {
  ValueNotifier<T> get notifier;
  void update(T newState);
  T get state;
}

class SimpleStateBridge<T> extends StateBridge<T> {
  final ValueNotifier<T> _notifier;

  SimpleStateBridge(T initialState) : _notifier = ValueNotifier<T>(initialState);

  @override
  ValueNotifier<T> get notifier => _notifier;

  @override
  T get state => _notifier.value;

  @override
  void update(T newState) {
    _notifier.value = newState;
  }
}
