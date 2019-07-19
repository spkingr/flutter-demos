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

class User{
  User(this.id, {this.userName, this.password, this.email, this.creationTime, this.information}){
    assert(userName != null);
    assert(password != null);
    assert(creationTime != null);
  }

  factory User.fromEmpty() => User(0, userName: "", password: "", email: "", creationTime: "", information: "");

  int id;
  String creationTime;
  String userName;
  String password;
  String email;
  String information;
}

class Book{
  Book(this.id, {this.name, this.price, this.authors, this.image}){
    assert(name != null);
    assert(price != null);
    assert(authors != null);
  }

  final int id;
  final String name;
  double price;
  String authors;
  Uint8List image;
}