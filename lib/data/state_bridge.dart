import 'package:flutter/material.dart';

abstract class StateBridge<T> {
  ValueNotifier<T> get notifier;
  void update(T newState);
}

class SimpleStateBridge<T> extends StateBridge<T> {
  final ValueNotifier<T> _notifier;

  SimpleStateBridge(T initialState) : _notifier = ValueNotifier(initialState);

  @override
  ValueNotifier<T> get notifier => _notifier;

  @override
  void update(T newState) {
    _notifier.value = newState;
  }
}
