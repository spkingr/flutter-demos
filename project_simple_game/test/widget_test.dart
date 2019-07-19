// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:project_simple_game/main.dart';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) => MaterialApp();
}

void main() {
  /*testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });*/

  group("Flame test", (){
    test("Test dimesion", (){
      final s1 = Size(0.0, 0.0);
      final s2 = const Size(0.0, 0.0);
      expect(s1, Size(0.0, 0.0));
      expect(s2, Size(0.0, 0.0));
    });
  });
}
