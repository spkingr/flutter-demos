import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'pages/page_home.dart';
import 'pages/page_books.dart';
import 'pages/page_add_book.dart';
import 'pages/page_view_book.dart';

class Navigation{

  static Router router;

  static void initRouter(){
    if(Navigation.router == null){
      Navigation.router = Router()
        ..define(HomePage.PAGE_NAME, handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => HomePage()))
        ..define(BooksPage.PAGE_NAME, handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => BooksPage()))
        ..define(AddBookPage.PAGE_NAME, handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => AddBookPage()))
        ..define(ViewBookPage.PAGE_NAME + ":" + ViewBookPage.PAGE_PARAM, handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => ViewBookPage(id: int.parse(params[ViewBookPage.PAGE_PARAM][0]))));
    }
  }

  static Future navigateTo(BuildContext context, String path, {
        int param,
        bool replace = false,
        TransitionType transition = TransitionType.fadeIn,
        Duration transitionDuration = const Duration(milliseconds: 250),
        RouteTransitionsBuilder transitionBuilder}
    ) => Navigation.router?.navigateTo(context, path + (param?.toString() ?? ""), replace: replace, transition: transition, transitionDuration: transitionDuration, transitionBuilder: transitionBuilder);
}

//router.define("/users/:id", handler: usersHandler);
//router.navigateTo(context, "/users/1234");