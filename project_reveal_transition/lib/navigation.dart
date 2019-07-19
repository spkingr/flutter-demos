import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/second_page.dart';

class Navigation{
  static Router router;

  static void initRouter(){
    Navigation.router = Router()
      ..define("/", handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => MyAppHome()))
      ..define("second_page", handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => MySecondPage()));
  }

  static void navigateTo(BuildContext context, String path, {
    bool replace = false,
    TransitionType transition = TransitionType.fadeIn,
    Duration transitionDuration = const Duration(milliseconds: 250),
    RouteTransitionsBuilder transitionBuilder
  }) => Navigation.router.navigateTo(context, path, replace: replace, transition: transition, transitionDuration: transitionDuration, transitionBuilder: transitionBuilder);
}