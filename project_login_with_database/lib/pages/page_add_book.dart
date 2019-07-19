import 'package:flutter/material.dart';
import 'dart:async';
import '../database/database_helper.dart';
import '../database/data_class.dart';
import '../widgets/widget_loader.dart';

class AddBookPage extends StatefulWidget{
  static const PAGE_NAME = "books_page/add_book_page/";

  @override
  _AddBookPage createState() => _AddBookPage();
}

class _AddBookPage extends State<AddBookPage>{
  final _keyForm = GlobalKey<FormState>();

  var _isSaving = false;
  var _book = Book.fromEmpty();

  BookProvider _bookProvider;

  @override
  void initState() {
    super.initState();
    final database = DatabaseHelper();
    database.bookProvider.then((BookProvider provider) {
      this._bookProvider = provider;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Add Book"), leading: IconButton(onPressed: this._onCancel, icon: Icon(Icons.close, color: Colors.red.shade200,),),),
    body: SafeArea(top: false, bottom: false, child: this._isSaving ? Stack(children: <Widget>[this._buildWidget(), SimpleLoader()]) : this._buildWidget(),),
    floatingActionButton: FloatingActionButton(onPressed: this._isSaving ? (){} : this._onAdd, child: Icon(Icons.done, color: Colors.white,),),
  );

  void _onAdd() async{
    if(this._bookProvider == null){
      return;
    }

    final state = this._keyForm.currentState;
    if(state == null || ! state.validate()){
      return;
    }

    state.save();

    this.setState(() => this._isSaving = true);
    this._book = await this._bookProvider.insert(this._book);

    Future.delayed(const Duration(seconds: 1)).then((_) => Navigator.of(this.context).pop(true));
  }

  Widget _buildWidget() => Form(
    key: this._keyForm,
    autovalidate: false,
    onWillPop: this._onLeaveWithoutSave,
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: this._buildRegisterTextFields(),
      ),
    ),
  );

  _buildRegisterTextFields() => <Widget>[
    TextFormField(
      autovalidate: false,
      onSaved: (text) => this._book.name = text,
      validator: this._validateBookName,
      decoration: InputDecoration(
        icon: Icon(Icons.book, color: Colors.green,),
        border: OutlineInputBorder(),
        labelText: "Title",
      ),
    ),

    const SizedBox(height: 10.0,),
    TextFormField(
      initialValue: "0.0",
      autovalidate: false,
      onSaved: (text) => this._book.price = double.parse(text),
      validator: this._validateBookPrice,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        icon: Icon(Icons.monetization_on, color: Colors.green,),
        border: OutlineInputBorder(),
        labelText: "Price",
      ),
    ),

    const SizedBox(height: 10.0,),
    TextFormField(
      autovalidate: false,
      onSaved: (text) => this._book.authors = text,
      validator: this._validateBookAuthors,
      decoration: InputDecoration(
        icon: Icon(Icons.people, color: Colors.orange,),
        border: OutlineInputBorder(),
        labelText: "Authors",
        helperText: "Multiple authors seperated with: /",
      ),
    ),

    const SizedBox(height: 10.0,),
    TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Information",
        helperText: "Tell somthing about this book, not required",
      ),
    ),

    const SizedBox(height: 10.0,),
    Image.asset("images/default_book.png", fit: BoxFit.cover,),
  ];

  String _validateBookName(String text) {
    if(text.isEmpty){
      return "Book name should not be empty!";
    }
    return null;
  }

  String _validateBookPrice(String text) {
    if(text.isEmpty){
      return "Book price should not be empty!";
    }
    final reg = RegExp(r'^[._0-9]+$');
    if(! reg.hasMatch(text)){
      return "Invalidate book price!";
    }
    return null;
  }

  String _validateBookAuthors(String text) {
    if(text.isEmpty){
      return "There are no authors?";
    }
    return null;
  }

  _onCancel() {
    this._closeKeyboard();

    if(this._isSaving){
      return;
    }

    this._onLeaveWithoutSave().then((leave) {
      if(leave){
        Navigator.of(this.context).pop(false);
      }
    });
  }

  Future<bool> _onLeaveWithoutSave() async{
    if(this._keyForm.currentState == null){
      return true;
    }
    final dialog = showDialog<bool>(
      context: this.context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Warning"),
        content: const Text("Leave without saving, are you sure?"),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.of(this.context).pop(true), child: const Text("Give Up"),),
          FlatButton(onPressed: () => Navigator.of(this.context).pop(false), child: const Text("Stay Here"),),
        ],
      ),
    );
    return dialog ?? false;
  }

  void _closeKeyboard() => FocusScope.of(this.context).requestFocus(FocusNode());
}
