import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart';

void main() {
  testWidgets('BoardView example smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the app title is displayed
    expect(find.text('BoardView Example'), findsOneWidget);

    // Verify that the board lists are displayed
    expect(find.text('To Do'), findsOneWidget);
    expect(find.text('In Progress'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    // Verify that some tasks are displayed
    expect(find.text('Task 1'), findsOneWidget);
    expect(find.text('Task 4'), findsOneWidget);
    expect(find.text('Task 6'), findsOneWidget);
  });
}