import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart';

void main() {
  testWidgets('BoardView example smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the app title is displayed
    expect(find.text('BoardView Example'), findsOneWidget);

    // Verify that the board lists are displayed (now appears in buttons too)
    expect(find.text('To Do'), findsNWidgets(2)); // Button + List header
    expect(find.text('In Progress'), findsNWidgets(2)); // Button + List header
    expect(find.text('Done'), findsNWidgets(2)); // Button + List header

    // Verify that some tasks are displayed
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 4'), findsOneWidget);
    expect(find.text('Task 6'), findsOneWidget);
  });
}