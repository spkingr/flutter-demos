import 'package:flutter/material.dart';
import '../database/data_class.dart';
import '../database/database_helper.dart';
import '../navigation.dart';
import '../pages/page_add_book.dart';
import '../pages/page_view_book.dart';

class BooksPage extends StatefulWidget{
  static const PAGE_NAME = "books_page/";

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage>{

  final _keyGlobal = GlobalKey<ScaffoldState>();
  final _controller = ScrollController();
  BookProvider _bookProvider;
  List<Book> _books;

  @override
  void initState() {
    super.initState();
    final database = DatabaseHelper();
    database.bookProvider.then((BookProvider provider) async {
      this._bookProvider = provider;
      final books = await this._bookProvider.selectAll();
      this.setState(() => this._books = books);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: this._keyGlobal,
    appBar: AppBar(title: const Text("Books"),),
    floatingActionButton: FloatingActionButton(onPressed: this.onAddClickListener, child: Icon(Icons.add,),),
    body: this._books == null ? Center(child: CircularProgressIndicator(),) : this._books.isEmpty ? Center(child: const Text("Empty books data."),) :
    ListView(controller: this._controller, children: this._books.map((book) => this._buildWidget(book)).toList(),),
  );

  void onAddClickListener() => Navigation.navigateTo(this.context, AddBookPage.PAGE_NAME).then((added) async{
    if(added != null && added){
      final books = await this._bookProvider.selectAll();
      this.setState(() => this._books = books);
      if(this._books.isNotEmpty){
        this._controller.animateTo(this._controller.position.maxScrollExtent, duration: const Duration(milliseconds: 800), curve: Curves.linear);
      }

      this._keyGlobal.currentState.showSnackBar(SnackBar(content: const Text("New item added."), action: SnackBarAction(label: "Done", onPressed: (){}),));
    }
  });

  Widget _buildWidget(Book book) => ListTile(
    title: Text(book.name),
    subtitle: Text(book.authors),
    trailing: Text(book.price.toString()),
    onTap: () => this._onViewBook(book),
  );

  void _onViewBook(Book book) => Navigation.navigateTo(this.context, ViewBookPage.PAGE_NAME, param: book.id);

  @override
  void dispose() {
    this._bookProvider.close();
    super.dispose();
  }
}