import 'package:flutter/material.dart';
import '../database/data_class.dart';
import '../database/database_helper.dart';

class BooksPage extends StatefulWidget{
  static const PAGE_NAME = "books_page/";

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage>{

  final database = DatabaseHelper();
  List<Book> books;

  @override
  void initState() {
    this.database.createAndOpenDatabase().then((_) => this.database.queryAllBooks().then((list) => this.setState(() =>this.books = list)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Books"),),
    floatingActionButton: FloatingActionButton(onPressed: this.onAddClickListener, child: Icon(Icons.add,),),
    body: this.books == null ? Center(child: CircularProgressIndicator(),) : this.books.isEmpty ? Center(child: const Text("Empty books data."),) :
    ListView(
      children: this.books.map((book) => this._buildWidget(book)).toList(),
    ),
  );

  //test
  void onAddClickListener() async{
    if(this.books == null || this.books.length >= 20){
      return;
    }
    /*await this.database.addBooks([
      Book(0, name: "爱因斯坦谈人生", price: 50.0, authors: "(美) 杜卡斯 (H.Dukas) / 霍夫曼 (B.Hoffmann)", image: null),
      Book(0, name: "百年孤独", price: 30.0, authors: "[哥伦比亚] 加西亚·马尔克斯", image: null),
      Book(0, name: "北岛诗选", price: 70.0, authors: "北岛", image: null),
      Book(0, name: "变化社会中的政治秩序", price: 110.0, authors: "[美] 塞缪尔·P·亨廷顿", image: null),
      Book(0, name: "博尔赫斯短篇小说集", price: 120.0, authors: "[阿根廷] 博尔赫斯", image: null),
      Book(0, name: "城堡", price: 0.0, authors: "[奥地利] 卡夫卡", image: null),
      Book(0, name: "丑陋的中国人", price: 0.0, authors: "柏杨", image: null),
      Book(0, name: "存在与时间", price: 0.0, authors: "[德] 马丁·海德格尔", image: null),
      Book(0, name: "存在与虚无", price: 0.0, authors: "[法] 萨特", image: null),
      Book(0, name: "大饭店", price: 0.0, authors: "阿瑟.黑利", image: null),
      Book(0, name: "第三次浪潮", price: 0.0, authors: "[美] 阿尔温·托夫勒", image: null),
      Book(0, name: "Seeds of discovery", price: 0.0, authors: "W. I. B Beveridge", image: null),
      Book(0, name: "傅雷家书", price: 0.0, authors: "傅敏", image: null),
      Book(0, name: "红楼启示录", price: 0.0, authors: "王蒙", image: null),
    ]);*/
    this.books = await this.database.queryAllBooks();
    this.setState((){});
  }

  Widget _buildWidget(Book book) => ListTile(
    title: Text(book.name),
    subtitle: Text(book.authors),
    trailing: Text(book.price.toString()),
  );
}