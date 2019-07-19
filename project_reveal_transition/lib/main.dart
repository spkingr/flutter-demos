import 'package:flutter/material.dart';
import 'navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  MyApp(){
    Navigation.initRouter();
  }

  @override
  Widget build(BuildContext context) => new MaterialApp(
    title: "?",
    theme: new ThemeData.light(),
    onGenerateRoute: Navigation.router.generator,
  );
}