// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart';

import 'package:project_send_screenshot/main.dart';

void main() {
  testWidgets('Take screenshot and save test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text("Click button to take a screen shot"), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byIcon(Icons.camera));
    await tester.pump();
    expect(find.text("Click button to take a screen shot"), findsOneWidget);
  });
}
