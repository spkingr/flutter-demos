import 'dart:typed_data';

/*const String _sql = """CREATE TABLE IF NOT EXISTS [user](
    [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [user_name] TEXT NOT NULL,
    [password] TEXT NOT NULL,
    [email] TEXT NOT NULL,
    [creation_time] TEXT NOT NULL,
    [information] TEXT DEFAULT NULL);

    CREATE TABLE IF NOT EXISTS [book](
    [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [name] TEXT NOT NULL,
    [price] REAL NOT NULL,
    [authors] TEXT NOT NULL,
    [image] BLOB DEFAULT NULL);""";*/

/*
await this._bookProvider.insertAll([
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
      Book(0, name: "红楼启示录王蒙", price: 0.0, authors: "王蒙", image: null),
    ]);
 */

abstract class DataObject{
  int get id;
  Map toMap();
}

class User extends DataObject{
  static const String TABLE_NAME = "user";
  static const String COLUMN_ID = "id";
  static const String COLUMN_USER_NAME = "user_name";
  static const String COLUMN_PASSWORD = "password";
  static const String COLUMN_EMAIL = "email";
  static const String COLUMN_CREATION_TIME = "creation_time";
  static const String COLUMN_INFORMATION = "information";

  User(this.id, {this.userName, this.password, this.email, this.creationTime, this.information}){
    assert(userName != null);
    assert(password != null);
    assert(creationTime != null);
  }

  User.fromEmpty(){
    this.id = 0;
    this.userName = "";
    this.password = "";
    this.email = "";
    this.creationTime = "";
    this.information = "";
  }

  int id;
  String creationTime;
  String userName;
  String password;
  String email;
  String information;

  User.fromMap(Map map){
    this.id = map.containsKey(User.COLUMN_ID) ? map[User.COLUMN_ID] : 0;
    this.userName = map.containsKey(User.COLUMN_USER_NAME) ? map[User.COLUMN_USER_NAME] : "";
    this.password = map.containsKey(User.COLUMN_PASSWORD) ? map[User.COLUMN_PASSWORD] : "";
    this.email = map.containsKey(User.COLUMN_EMAIL) ? map[User.COLUMN_EMAIL] : "";
    this.creationTime = map.containsKey(User.COLUMN_CREATION_TIME) ? map[User.COLUMN_CREATION_TIME] : "";
    this.information = map.containsKey(User.COLUMN_INFORMATION) ? map[User.COLUMN_INFORMATION] : "";
  }

  @override
  Map<String, dynamic> toMap() {
    return {/*User.COLUMN_ID : this.id,*/
      User.COLUMN_USER_NAME : this.userName,
      User.COLUMN_PASSWORD : this.password,
      User.COLUMN_EMAIL : this.email,
      User.COLUMN_CREATION_TIME : this.creationTime,
      User.COLUMN_INFORMATION : this.information ?? ""};
  }
}

class Book extends DataObject{
  static const String TABLE_NAME = "book";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_PRICE = "price";
  static const String COLUMN_AUTHORS = "authors";
  static const String COLUMN_IMAGE = "image";

  Book(this.id, {this.name, this.price, this.authors, this.image}){
    assert(name != null);
    assert(price != null);
    assert(authors != null);
  }

  int id;
  String name;
  double price;
  String authors;
  Uint8List image;

  Book.fromMap(Map map){
    this.id = map.containsKey(Book.COLUMN_ID) ? map[Book.COLUMN_ID] : 0;
    this.name = map.containsKey(Book.COLUMN_NAME) ? map[Book.COLUMN_NAME] : "";
    this.price = map.containsKey(Book.COLUMN_PRICE) ? map[Book.COLUMN_PRICE] : "";
    this.authors = map.containsKey(Book.COLUMN_AUTHORS) ? map[Book.COLUMN_AUTHORS] : "";
    this.image = map.containsKey(Book.COLUMN_IMAGE) ? map[Book.COLUMN_IMAGE] : null;
  }

  Book.fromEmpty(){
    this.id = 0;
    this.name = "";
    this.price = 0.0;
    this.authors = "";
    this.image = null;
  }

  @override
  Map toMap() {
    final map = {/*Book.COLUMN_ID : this.id,*/
      Book.COLUMN_NAME : this.name,
      Book.COLUMN_PRICE : this.price,
      Book.COLUMN_AUTHORS : this.authors};

    if(this.image != null){
      map[Book.COLUMN_IMAGE] = this.image;
    }

    return map;
  }
}
