@Timeout(const Duration(seconds: 10))

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:project_reactive_flutter/pages/page_book_list.dart';

import 'package:project_reactive_flutter/main.dart';

void main() {
  testWidgets('Image file test', (WidgetTester tester) async {
    var dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path, "images/default_book.png");
    var file = File(path);
    var isExists = await file.exists();
    print("____________________file: $isExists}");
    expect(isExists, isTrue);
  }, skip: true);

  testWidgets('Stream test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: BooksPage(),));
    expect(find.byIcon(Icons.search), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), "a");
    await tester.pump(const Duration(seconds: 3));
    await tester.enterText(find.byType(TextField), "a ");
    await tester.pump(const Duration(seconds: 2));
    await tester.enterText(find.byType(TextField), " a");
    await tester.pump(const Duration(seconds: 3));
    await tester.enterText(find.byType(TextField), " a  ");
    await tester.showKeyboard(find.byType(TextField));
    await tester.pump(const Duration(seconds: 5));
  }, timeout: Timeout(const Duration(seconds: 20)));
}
