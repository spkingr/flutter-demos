import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'pages/page_home.dart';
import 'pages/page_books.dart';

class Navigation{

  static Router router;

  static void initRouter(){
    if(Navigation.router == null){
      Navigation.router = Router()
        ..define(HomePage.PAGE_NAME, handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => HomePage()))
        ..define(BooksPage.PAGE_NAME, handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => BooksPage()));
    }
  }

  static void navigateTo(BuildContext context, String path, {
        bool replace = false,
        TransitionType transition = TransitionType.native,
        Duration transitionDuration = const Duration(milliseconds: 250),
        RouteTransitionsBuilder transitionBuilder}
    ) => Navigation.router?.navigateTo(context, path, replace: replace, transition: transition, transitionDuration: transitionDuration, transitionBuilder: transitionBuilder);
}