import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ContactFormState {
  final String name;
  final String email;
  final String message;
  final bool sending;
  final String? errorMessage;
  final bool sent;

  const ContactFormState({
    this.name = '',
    this.email = '',
    this.message = '',
    this.sending = false,
    this.errorMessage,
    this.sent = false,
  });

  bool get isValid =>
      name.trim().isNotEmpty &&
      _emailRegex.hasMatch(email.trim()) &&
      message.trim().isNotEmpty;

  ContactFormState copyWith({
    String? name,
    String? email,
    String? message,
    bool? sending,
    String? Function()? errorMessage,
    bool? sent,
  }) {
    return ContactFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
      sending: sending ?? this.sending,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      sent: sent ?? this.sent,
    );
  }
}

final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

class ContactFormNotifier extends Notifier<ContactFormState> {
  @override
  ContactFormState build() => const ContactFormState();

  void setName(String value) => state = state.copyWith(name: value, errorMessage: () => null);
  void setEmail(String value) => state = state.copyWith(email: value, errorMessage: () => null);
  void setMessage(String value) => state = state.copyWith(message: value, errorMessage: () => null);

  Future<void> submit() async {
    if (!state.isValid) return;

    state = state.copyWith(sending: true, errorMessage: () => null);

    try {
      final response = await http.post(
        Uri.parse('https://formsubmit.co/ajax/dev.bahy1@gmail.com'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': state.name.trim(),
          'email': state.email.trim(),
          'message': state.message.trim(),
          '_subject': 'New Contact Form Message from SFWF',
        }),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(
          sending: false,
          sent: true,
          name: '',
          email: '',
          message: '',
        );
      } else {
        state = state.copyWith(
          sending: false,
          errorMessage: () => 'Failed to send message. Please try again later.',
        );
      }
    } catch (_) {
      state = state.copyWith(
        sending: false,
        errorMessage: () => 'Network error. Please check your connection and try again.',
      );
    }
  }

  void reset() => state = const ContactFormState();
}

final contactFormProvider =
    NotifierProvider<ContactFormNotifier, ContactFormState>(ContactFormNotifier.new);
