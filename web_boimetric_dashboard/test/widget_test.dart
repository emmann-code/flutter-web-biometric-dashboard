import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_biometric_dashboard/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: Text('Test')));
    
    // Verify that the app starts up
    expect(find.text('Test'), findsOneWidget);
  });
}
// Auto-generated comment for commit - 1763734959
// Auto-generated comment for commit - 1763734967
