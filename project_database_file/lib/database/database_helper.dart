import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'data_class.dart';

class DatabaseHelper{
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static const String DATABASE_NAME = "my_flutter_db.sqlite3";
  static const String TABLE_USER = "user";
  static const String TABLE_BOOK = "book";

  factory DatabaseHelper(){
    return DatabaseHelper._instance;
  }

  Database _database;

  createAndOpenDatabase([bool forceDelete = false]) async{
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, DatabaseHelper.DATABASE_NAME);

    print("_____________________________database path: $path");

    final fileExists = await File(path).exists();
    if(forceDelete && fileExists){
      await deleteDatabase(path);
    }

    final sql = """CREATE TABLE IF NOT EXISTS [${DatabaseHelper.TABLE_USER}](
    [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [user_name] TEXT NOT NULL,
    [password] TEXT NOT NULL,
    [email] TEXT NOT NULL,
    [creation_time] TEXT NOT NULL,
    [information] TEXT DEFAULT NULL);

    CREATE TABLE IF NOT EXISTS [${DatabaseHelper.TABLE_BOOK}](
    [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [name] TEXT NOT NULL,
    [price] REAL NOT NULL,
    [authors] TEXT NOT NULL,
    [image] BLOB DEFAULT NULL);""";

    this._database = await openDatabase(path, version: 3, onCreate: (Database db, int version) async {
      await db.execute(sql);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      var sql = """CREATE TABLE IF NOT EXISTS [${DatabaseHelper.TABLE_USER}](
      [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      [user_name] TEXT NOT NULL,
      [password] TEXT NOT NULL,
      [email] TEXT NOT NULL,
      [creation_time] TEXT NOT NULL,
      [information] TEXT DEFAULT NULL);""";
      await db.execute(sql);

      sql = """CREATE TABLE IF NOT EXISTS [${DatabaseHelper.TABLE_BOOK}](
      [id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      [name] TEXT NOT NULL,
      [price] REAL NOT NULL,
      [authors] TEXT NOT NULL,
      [image] BLOB DEFAULT NULL);""";
      await db.execute(sql);
    });
  }

  register({String userName, String password, String email, String information}) async {
    int id;
    await this._database.transaction((transition) async {
      final date = DateTime.now().toIso8601String();
      final sql = """INSERT INTO [${DatabaseHelper.TABLE_USER}]
      ([user_name], [password], [email], [creation_time], [information]) VALUES
      ("$userName", "$password", "$email", "$date", ${information == null ? 'NULL' : '"$information"'});
      """;
      id = await transition.rawInsert(sql);
    });
    return id;
  }

  selectUser(String email, String password) async{
    User user;
    final sql = """SELECT * FROM [${DatabaseHelper.TABLE_USER}] WHERE  [email] = "$email" AND [password] = "$password";""";
    final users = await this._database.rawQuery(sql);
    if(users.isNotEmpty){
      var map = users.first;
      user = User(map["id"], userName: map["user_name"], password: map["password"], email: map["email"], creationTime: map["creation_time"], information: map["information"]);
    }
    return user;
  }

  queryAllBooks() async {
    final books = <Book>[];
    final sql = """SELECT * FROM [${DatabaseHelper.TABLE_BOOK}]""";
    final maps = await this._database.rawQuery(sql);
    for(var map in maps){
      final book = Book(map["id"], name: map["name"], price: map["price"], authors: map["authors"], image: map["image"]);
      books.add(book);
    }
    return books;
  }

  addBooks(List<Book> books) async {
    final batch = this._database.batch();
    for(var book in books){
      //var sql = """INSERT INTO [] ([name], [price], [authors]) VALUES ("${book.name}", ${book.price}, "${book.authors}");""";
      batch.insert(DatabaseHelper.TABLE_BOOK, {"name":book.name, "price":book.price, "authors":book.authors});
    }
    return await batch.commit();
  }

  deleteBook(int id) async {
    final sql = """DELETE FROM [${DatabaseHelper.TABLE_BOOK}] WHERE [id] = $id""";
    return await this._database.rawDelete(sql);
  }

  close() async{
    await this._database.close();
  }
}

/*
// Count the records
count = Sqflite.firstIntValue(await database.rawQuery("SELECT COUNT(*) FROM Test"));
assert(count == 2);
 */