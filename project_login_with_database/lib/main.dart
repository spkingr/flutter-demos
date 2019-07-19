import 'package:flutter/material.dart';
import 'navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  MyApp(){
    Navigation.initRouter();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "?",
    theme: ThemeData.light(),
    onGenerateRoute: Navigation.router.generator,
  );
}