import 'package:flutter/material.dart';
import '../database/data_class.dart';
import '../database/database_helper.dart';
import '../navigation.dart';
import '../pages/page_book_detail.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

/// 1. How to cancel the stream?
/// 2. How to re-open the stream after close it
/// 3. How to set time out for the actions in stream
/// 4. And...
class BooksPage extends StatefulWidget{
  static const PAGE_NAME = "/";

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage>{

  final _controller = ScrollController();
  BookProvider _bookProvider;
  List<Book> _books;
  final _textController = TextEditingController();

  var _isSearchMode = false;
  var _isInSearching = false;
  List<Book> _searchResults;
  String _errorMessage;

  // ignore: close_sinks
  final _replaySubject = ReplaySubject<String>(maxSize: 1);

  @override
  void initState() {
    super.initState();
    final database = DatabaseHelper();
    database.bookProvider.then((BookProvider provider) async {
      this._bookProvider = provider;
      final books = await this._bookProvider.selectAll();
      this.setState(() => this._books = books);
    });

    this._replaySubject.stream
        .distinct((String a, String b) => a.trim() == b.trim())
        .debounce(const Duration(seconds: 2))
        .where((String text) => text.length >= 2)
        //.timeout(const Duration(seconds: 5))
        .handleError(this._onError)
        .listen((String text) async => await this._onSearch(text));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Books"),
      bottom: this._isSearchMode ? this._buildSearchBar() : null,
      actions: (this._books == null || this._books.isEmpty) ? null
          : <Widget>[IconButton(icon: this._isSearchMode ? Icon(Icons.close,) : Icon(Icons.search), onPressed: this._onAction)],
    ),
    body: this._getBody(),
    floatingActionButton: FloatingActionButton(onPressed: this.onAddClickListener, child: Icon(Icons.add,),),
  );

  Widget _getBody(){
    if(! this._isSearchMode || this._textController.text.isEmpty){
      return this._books == null ? Center(child: CircularProgressIndicator(),)
          : (this._books.isEmpty ? Center(child: const Text("Empty books data."),)
          : ListView(controller: this._controller, children: this._books.map((book) => this._buildWidget(book)).toList(),));
    }else{
      if(this._isInSearching){
        return Center(child: CircularProgressIndicator(),);
      }else{
        return (this._errorMessage != null) ? Center(child: Text("Error while searching, try later. \nMessage: ${this._errorMessage}"),)
            : (this._searchResults == null ? Center(child: const Text("No searchs presented now!"),)
            : (this._searchResults.isEmpty ? Center(child: const Text("No search result matches."),)
            : ListView(controller: this._controller, children: this._searchResults.map((book) => this._buildWidget(book)).toList(),)));
      }
    }
  }

  void _onAction(){
    this.setState(() => this._isSearchMode = ! this._isSearchMode);
    if(! this._isSearchMode){
      this._textController.clear();
      this._isInSearching = false;
      this._searchResults = null;

      this._replaySubject.add("");//Trigger the distinct filter.
    }
  }

  Widget _buildSearchBar() => PreferredSize(
    preferredSize: Size(0.0, 72.0),
    child: Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: TextField(
        controller: this._textController,
        onChanged: this._onTextChange,
        onSubmitted: this._onTextChange,
        decoration: InputDecoration(
          hintText: "Search",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),),
          prefixIcon: Icon(Icons.search, color: Colors.grey,),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    ),
  );

  Future _onSearch(String text) async{
    this._errorMessage = null;
    if(! this._isInSearching){
      this.setState(() => this._isInSearching = true);
    }

    this._bookProvider = /*this._bookProvider ?? */await DatabaseHelper().bookProvider; //Weired! the database is always auto close
    this._searchResults = await this._bookProvider.searchBooks(name: text, authors: text, description: text);
    //----------------- test ---------------
    await Future.delayed(Duration(seconds: Random().nextInt(3)));
    if(this._isSearchMode && this.mounted){
      this.setState(() => this._isInSearching = false);
    }
  }

  void _onError(error){
    this.setState((){
      this._isInSearching = false;
      this._searchResults = null;
      this._errorMessage = error.toString();
    });
  }

  void _onTextChange(String text){
    /*if(text.trim().isEmpty || text.trim().length < 2){
      //return
    }*/
    this._replaySubject.add(text);
  }

  void onAddClickListener() => Navigation.navigateTo(this.context, BookDetailPage.PAGE_NAME).then((added) async{
    if(added != null && added){
      await this._loadBooks();
    }
  });

  Widget _buildWidget(Book book) => ListTile(
    title: Text(book.name),
    subtitle: Text(book.authors),
    trailing: Text(book.price.toString()),
    onTap: () => this._onViewBook(book),
  );

  void _onViewBook(Book book) => Navigation.navigateTo(this.context, BookDetailPage.PAGE_NAME, param: book.id).then((edited) async {
    if(edited != null && edited){
      await this._loadBooks();
    }
  });

  _loadBooks() async{
    final books = await this._bookProvider.selectAll();
    this.setState(() => this._books = books);
    this._controller.animateTo(this._controller.position.maxScrollExtent, duration: const Duration(milliseconds: 800), curve: Curves.linear);
  }

  @override
  void dispose() {
    this._bookProvider?.close();
    this._replaySubject.close();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    if(this._isSearchMode){
      return;
    }
    this._isSearchMode = false;
    this._isInSearching = false;
    this._searchResults = null;
  }
}