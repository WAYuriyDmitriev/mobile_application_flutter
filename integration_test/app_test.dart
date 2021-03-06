// This is a basic Flutter integration test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:untitled2/main.dart' as app;

void main() {
  _testMain();
}

void _testMain() {
  testWidgets('Тест на наличие всех иконок', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.clear));
    await tester.tap(find.byIcon(Icons.sync));
    await tester.tap(find.byIcon(Icons.map));
    await tester.tap(find.byIcon(Icons.check));
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.tap(find.byIcon(Icons.location_on));
    await tester.tap(find.byIcon(Icons.location_off));
    await tester.pump();
  });
}
