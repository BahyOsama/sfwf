import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bahy_developer/main.dart';

void main() {
  testWidgets('App smoke test - renders without crashing', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SFWFShowcaseApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify the app renders
    expect(find.byType(MaterialApp), findsOneWidget, reason: 'MaterialApp should be present');

    // Verify the home page shows content
    expect(find.text('Smart Flutter Web Framework'), findsOneWidget,
        reason: 'Home page hero title should be visible');
    expect(find.text('Why SFWF?'), findsOneWidget,
        reason: 'Features section title should be visible');
    expect(find.text('Ready to Build?'), findsOneWidget,
        reason: 'CTA section should be visible');
  });
}
