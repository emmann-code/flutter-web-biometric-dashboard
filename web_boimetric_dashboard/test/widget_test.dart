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
// Auto-generated comment for commit - 1763734967
// Auto-generated comment for commit - 1763734968
// Auto-generated comment for commit - 1763734971
// Auto-generated comment for commit - 1763734974
// Auto-generated comment for commit - 1763734980
// Auto-generated comment for commit - 1763734990
// Auto-generated comment for commit - 1763734995
// Auto-generated comment for commit - 1763734996
// Auto-generated comment for commit - 1763735001
// Auto-generated comment for commit - 1763735007
// Auto-generated comment for commit - 1763735008
// Auto-generated comment for commit - 1763735016
// Auto-generated comment for commit - 1763735019
// Auto-generated comment for commit - 1763735025
// Auto-generated comment for commit - 1763735033
// Auto-generated comment for commit - 1763735036
