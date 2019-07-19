import 'dart:typed_data';


/*
   async{
    await this._bookProvider.insertAll([
      Book(0, name: "爱因斯坦谈人生", price: 50.0, authors: "(美) 杜卡斯 (H.Dukas) / 霍夫曼 (B.Hoffmann)", image: null, description: ""),
      Book(0, name: "百年孤独", price: 30.0, authors: "[哥伦比亚] 加西亚·马尔克斯", image: null, description: ""),
      Book(0, name: "北岛诗选", price: 70.0, authors: "北岛", image: null, description: ""),
      Book(0, name: "变化社会中的政治秩序", price: 110.0, authors: "[美] 塞缪尔·P·亨廷顿", image: null, description: ""),
      Book(0, name: "博尔赫斯短篇小说集", price: 120.0, authors: "[阿根廷] 博尔赫斯", image: null, description: ""),
      Book(0, name: "城堡", price: 0.0, authors: "[奥地利] 卡夫卡", image: null, description: ""),
      Book(0, name: "丑陋的中国人", price: 0.0, authors: "柏杨", image: null, description: ""),
      Book(0, name: "存在与时间", price: 0.0, authors: "[德] 马丁·海德格尔", image: null, description: ""),
      Book(0, name: "存在与虚无", price: 0.0, authors: "[法] 萨特", image: null, description: ""),
      Book(0, name: "大饭店", price: 0.0, authors: "阿瑟.黑利", image: null, description: ""),
      Book(0, name: "第三次浪潮", price: 0.0, authors: "[美] 阿尔温·托夫勒", image: null, description: ""),
      Book(0, name: "Seeds of discovery", price: 0.0, authors: "W. I. B Beveridge", image: null, description: ""),
      Book(0, name: "傅雷家书", price: 0.0, authors: "傅敏", image: null, description: ""),
      Book(0, name: "红楼启示录王蒙", price: 0.0, authors: "王蒙", image: null, description: ""),
    ]);
  } */


class Book{
  static const String TABLE_NAME = "book";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_PRICE = "price";
  static const String COLUMN_AUTHORS = "authors";
  static const String COLUMN_DESCRIPTION = "description";
  static const String COLUMN_IMAGE = "image";

  Book(this.id, {this.name, this.price, this.authors, this.description, this.image});

  Book.fromEmpty(){
    this.id = 0;
    this.name = "";
    this.price = 0.0;
    this.authors = "";
    this.description = "";
    this.image = null;
  }

  Book.fromCopy(Book other){
    this.id = other.id;
    this.name = other.name;
    this.price = other.price;
    this.authors = other.authors;
    this.description = other.description;
    this.image = other.image;
  }

  Book.fromMap(Map<String, dynamic> map){
    this.id = map.containsKey(Book.COLUMN_ID) ? map[Book.COLUMN_ID] : 0;
    this.name = map.containsKey(Book.COLUMN_NAME) ? map[Book.COLUMN_NAME] : "";
    this.price = map.containsKey(Book.COLUMN_PRICE) ? map[Book.COLUMN_PRICE] : "";
    this.authors = map.containsKey(Book.COLUMN_AUTHORS) ? map[Book.COLUMN_AUTHORS] : "";
    this.description = map.containsKey(Book.COLUMN_DESCRIPTION) ? map[Book.COLUMN_DESCRIPTION] : "";
    this.image = map.containsKey(Book.COLUMN_IMAGE) ? map[Book.COLUMN_IMAGE] : null;
  }

  int id;
  String name;
  double price;
  String authors;
  String description;
  Uint8List image;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      /*Book.COLUMN_ID : this.id,*/
      Book.COLUMN_NAME : this.name,
      Book.COLUMN_PRICE : this.price,
      Book.COLUMN_AUTHORS : this.authors,
      Book.COLUMN_DESCRIPTION : this.description,
    };

    if(this.image != null){
      map[Book.COLUMN_IMAGE] = this.image;
    }

    return map;
  }
}