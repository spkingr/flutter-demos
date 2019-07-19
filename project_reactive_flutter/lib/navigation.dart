import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'pages/page_book_list.dart';
import 'pages/page_book_detail.dart';

class Navigation{

  static Router _router;

  static get generator{
    return Navigation._router?.generator;
  }

  static int _getParamId(dynamic param){
    try{
      return int.parse(param);
    }catch(e){
    }
    return null;
  }

  static void initRouter(){
    if(Navigation._router == null){
      Navigation._router = Router()
        ..define(BooksPage.PAGE_NAME, handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => BooksPage()))
        ..define(BookDetailPage.PAGE_NAME + ":" + BookDetailPage.PAGE_PARAM, handler: Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => BookDetailPage(id: Navigation._getParamId(params[BookDetailPage.PAGE_PARAM][0]))));
    }
  }

  static Future navigateTo(BuildContext context, String path, {
        int param,
        bool replace = false,
        TransitionType transition = TransitionType.native,
        Duration transitionDuration = const Duration(milliseconds: 250),
        RouteTransitionsBuilder transitionBuilder}
    ) => Navigation._router?.navigateTo(context, path + (param?.toString() ?? ""), replace: replace, transition: transition, transitionDuration: transitionDuration, transitionBuilder: transitionBuilder);
}

//router.define("/users/:id", handler: usersHandler);
//router.navigateTo(context, "/users/1234");