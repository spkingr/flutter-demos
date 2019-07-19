import 'dart:io' as IO;
import 'package:image/image.dart' as ImageData;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../database/data_class.dart';
import '../widgets/widget_loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

enum PageType{
  TypeView, TypeEdit, TypeAdd
}

const IMAGE_SIZE = 256;

class BookDetailPage extends StatefulWidget{
  static const PAGE_NAME = "view_book_page/";
  static const PAGE_PARAM = "id";

  BookDetailPage({this.id});

  final int id;

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage>{
  int get _id => this.widget.id;
  PageType get _type => this._id == null ? PageType.TypeAdd : (this._isEditMode ? PageType.TypeEdit : PageType.TypeView);
  var _isEditMode = false;
  var _isWaiting;
  BookProvider _bookProvider;
  Book _book;
  Book _bookBackup;
  Uint8List _imageBook;

  final _keyGlobal = GlobalKey<ScaffoldState>();
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if(this._type == PageType.TypeAdd){
      this._isWaiting = false;
      this._book = Book.fromEmpty();
    }else{
      this._isWaiting = true;
    }

    final database = DatabaseHelper();
    database.bookProvider.then((BookProvider provider) {
      this._bookProvider = provider;

      if(this._id != null){
        this._bookProvider.select(this._id).then((Book book) => this.setState((){
          this._isWaiting = false;
          this._book = book;
        }));
      }
    });
  }

  @override
  void dispose() {
    this._bookProvider?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: this._keyGlobal,
    appBar: this._buildAppBar(),
    floatingActionButton: FloatingActionButton(onPressed: this._onAction, child: this._buildFloatingButton(),),
    body: SafeArea(
      top: false,
      bottom: false,
      child: this._buildWidget(),
    ),
  );

  void _onAction() async{
    if(this._isWaiting){
      return;
    }

    if(this._type == PageType.TypeAdd || this._type == PageType.TypeEdit){
      if(this._bookProvider == null){
        return;
      }
      final state = this._keyForm.currentState;
      if(state == null || ! state.validate()){
        return;
      }
      state.save();
      this.setState(() => this._isWaiting = true);

      try {
        this._type == PageType.TypeAdd ? this._book = await this._bookProvider.insert(this._book) : await this._bookProvider.update(this._book);
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(this.context).pop(true);
      } catch (e) {
        this.setState(() => this._isWaiting = false);
        this._keyGlobal.currentState.showSnackBar(SnackBar(content: Text("Error: ${e.toString()}", overflow: TextOverflow.fade, softWrap: true,), duration: const Duration(seconds: 2), action: SnackBarAction(label: "Done", onPressed: (){}),));
      }

    }else if(this._type == PageType.TypeView){
      this._bookBackup = Book.fromCopy(this._book);
      this.setState(() => this._isEditMode = true);
    }
  }

  Widget _buildAppBar(){
    AppBar appBar;
    switch(this._type){
      case PageType.TypeView:
        appBar = AppBar(title: Text(this._book == null ? "Book ${this.widget.id}" : this._book.name), );
        break;
      case PageType.TypeAdd:
        appBar = AppBar(title: Text("Add New"), leading: IconButton(onPressed: this._onCancel, icon: Icon(Icons.cancel, color: Colors.red,),),);
        break;
      case PageType.TypeEdit:
        appBar = AppBar(title: Text(this._book == null ? "Book ${this.widget.id}" : this._book.name), actions: <Widget>[IconButton(onPressed: this._onCancel, icon: Icon(Icons.settings_backup_restore, color: Colors.green,),),],);
        break;
    }
    return appBar;
  }

  Widget _buildFloatingButton(){
    Icon icon;
    switch(this._type){
      case PageType.TypeView:
        icon = Icon(Icons.edit, color: Colors.orange,);
        break;
      case PageType.TypeAdd:
        icon = Icon(Icons.done, color: Colors.white,);
        break;
      case PageType.TypeEdit:
        icon = Icon(Icons.done, color: Colors.white,);
        break;
    }
    return icon;
  }

  Widget _buildEmpty() => Center(child: Text("No such book!"),);

  Widget _buildWidget(){
    Widget widget;
    switch(this._type){
      case PageType.TypeAdd:
        widget = this._isWaiting ? SimpleLoader() : this._buildFormWidget();
        break;
      case PageType.TypeView:
        widget = this._isWaiting ? SimpleLoader() : (this._book == null ? this._buildEmpty() : this._buildFormWidget());
        break;
      case PageType.TypeEdit:
        widget = this._isWaiting ? SimpleLoader() : this._buildFormWidget();
        break;
    }
    return widget;
  }

  Widget _buildFormWidget() => Form(
    key: this._keyForm,
    autovalidate: false,
    onWillPop: this._onLeaveWithoutSave,
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: this._buildTextFields(),
      ),
    ),
  );

  List<Widget> _buildTextFields() => <Widget>[
    TextFormField(
      enabled: this._type != PageType.TypeView,
      initialValue: this._book?.name ?? "---",
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
      enabled: this._type != PageType.TypeView,
      initialValue: this._book?.price?.toString() ?? "---",
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
      enabled: this._type != PageType.TypeView,
      initialValue: this._book?.authors ?? "-/-/-/",
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
      enabled: this._type != PageType.TypeView,
      initialValue: this._book?.description ?? "",
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Information",
        helperText: "Tell somthing about this book, not required",
      ),
    ),

    const SizedBox(height: 10.0,),
    Stack(
      fit: StackFit.loose,
      alignment: AlignmentDirectional(0.0, 0.0),
      children: <Widget>[
        this._imageBook == null ? Image.asset("images/default_book.png", fit: BoxFit.contain,) : Image.memory(this._imageBook,),
        //this._imageFile == null ? Image.asset("images/default_book.png", fit: BoxFit.contain,) : Image.file(this._imageFile,),
        this._type == PageType.TypeView ? Center() : GestureDetector(
            onTap: this._onSelectImage,
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withAlpha(128),borderRadius: BorderRadius.circular(6.0)),
              padding: const EdgeInsets.all(16.0),
              child: Text("Click to select image", style: TextStyle(color: Colors.white, fontSize: 24.0, ),),
            )
        ),
      ],
    ),
  ];

  Future _onSelectImage() async{
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imageFile == null){
      return;
    }

    final bytes = await imageFile.readAsBytes();
    ImageData.Image imageData = ImageData.decodeImage(bytes);
    ImageData.Image thumbnail = ImageData.copyResize(imageData, IMAGE_SIZE);
    this.setState(() => this._imageBook = thumbnail.getBytes());

    print("________________________________________________Path: ${imageFile.path}");
  }

  void _onCancel() {
    this._closeKeyboard();

    if(this._isWaiting){
      return;
    }

    if(this._isEditMode){
      this._book = Book.fromCopy(this._bookBackup);
      this.setState(() => this._isEditMode = false);
      return;
    }

    this._onLeaveWithoutSave().then((leave) {
      if(leave){
        Navigator.of(this.context).pop(false);
      }
    });
  }

  Future<bool> _onLeaveWithoutSave() async{
    if(this._keyForm.currentState == null || ! this._isEditMode){
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

  void _closeKeyboard() => FocusScope.of(this.context).requestFocus(FocusNode());
}
