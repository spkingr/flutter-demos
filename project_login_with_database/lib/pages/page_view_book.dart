import 'package:flutter/material.dart';
import 'dart:async';
import '../database/database_helper.dart';
import '../database/data_class.dart';
import '../widgets/widget_loader.dart';

class ViewBookPage extends StatefulWidget{
  static const PAGE_NAME = "books_page/view_book_page/";
  static const PAGE_PARAM = "id";

  ViewBookPage({this.id});

  final int id;

  @override
  _ViewBookPage createState() => _ViewBookPage();
}

class _ViewBookPage extends State<ViewBookPage>{
  var _isWaiting = true;
  Book _book;
  String get _appBarTitle => this._book == null ? "Book ${this.widget.id}" : this._book.name;

  BookProvider _bookProvider;

  @override
  void initState() {
    super.initState();
    final database = DatabaseHelper();
    database.bookProvider.then((BookProvider provider) {
      this._bookProvider = provider;
      this._bookProvider.select(this.widget.id).then((book) => this.setState((){
        this._isWaiting = false;
        this._book = book;
      }));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(this._appBarTitle), /*leading: IconButton(onPressed: () => Navigator.of(this.context).pop(), icon: Icon(Icons.close, color: Colors.red.shade200,),),*/),
    body: SafeArea(top: false, bottom: false, child: this._isWaiting ? SimpleLoader() : (this._book == null ? this._buildEmpty() : this._buildWidget()),),
  );

  Widget _buildEmpty() => Center(child: Text("No such book!"),);

  Widget _buildWidget() => Column(
    children: <Widget>[
      Image.asset("images/default_book.png", fit: BoxFit.cover,),
      ListTile(leading: Icon(Icons.book, color: Colors.green,), title: Text("${this._book?.name ?? "---"}"),),
      ListTile(leading: Icon(Icons.people, color: Colors.orange,), title: Text("${this._book?.authors ?? "-/-/-"}"),),
      ListTile(leading: Icon(Icons.monetization_on, color: Colors.red,), trailing: Text("￥${this._book?.price ?? "---"}"),),
    ],
  );
}
