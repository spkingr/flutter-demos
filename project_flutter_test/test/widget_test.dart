import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:project_flutter_test/main.dart';

void main() {
  testWidgets('Widgets should work property', (WidgetTester tester) async{
    final sliderKey = UniqueKey();
    var value = 0.0;
    await tester.pumpWidget(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) => MaterialApp(
        home: Material(
          child: Center(
            child: Slider(key: sliderKey, value: value, onChanged: (double newValue) => setState(() => value = newValue)),
          ),
        ),
      )),
    );
    expect(value, equals(0.0));
    await tester.tap(find.byKey(sliderKey));
    expect(value, equals(0.5));
  });

  testWidgets('The home app is clicked and watch the console output', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text("Test"), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home));
    await tester.pump();

    expect(find.text("Home"), findsNothing);

    //debugDumpApp();
  });

  testWidgets('Test debug dump app to visualize the app', (WidgetTester tester){
    debugDumpApp();
  });
}

void debugDumpApp() {
  assert(WidgetsBinding.instance != null);
  String mode = 'RELEASE MODE';
  assert(() { mode = 'CHECKED MODE'; return true; }());
  debugPrint('${WidgetsBinding.instance.runtimeType} - $mode');
  if (WidgetsBinding.instance.renderViewElement != null) {
    debugPrint(WidgetsBinding.instance.renderViewElement.toStringDeep());
  } else {
    debugPrint('<no tree currently mounted>');
  }
}