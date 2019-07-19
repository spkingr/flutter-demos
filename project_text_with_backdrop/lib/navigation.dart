import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'pages/page_home.dart';
import 'pages/page_text_field.dart';
import 'pages/page_scrollable_Tabs.dart';
import 'pages/page_backdrop.dart';

class Navigation{

  static Router router;

  static void initRouter(){
    Navigation.router = Router()
      ..define(HomePage.PAGE_NAME, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => HomePage()))
      ..define(TextFieldPage.PAGE_NAME, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => TextFieldPage()))
      ..define(BackdropPage.PAGE_NAME, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => BackdropPage()))
      ..define(ScrollableTabsPage.PAGE_NAME, handler: Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) => ScrollableTabsPage()));
  }

  static void navigateTo(BuildContext context, String path, {
        bool replace = false,
        TransitionType transition = TransitionType.native,
        Duration transitionDuration = const Duration(milliseconds: 250),
        RouteTransitionsBuilder transitionBuilder}
    ) => Navigation.router?.navigateTo(context, path, replace: replace, transition: transition, transitionDuration: transitionDuration, transitionBuilder: transitionBuilder);
}