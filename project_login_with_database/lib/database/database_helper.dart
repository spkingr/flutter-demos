import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'data_class.dart';

class UserProvider{
  Database _database;
  int _version = 0;

  Future open(String path, {int version = 1}) async{
    if(this._database != null && version == this._version){
      return;
    }

    this._version = version;

    final sql = """CREATE TABLE IF NOT EXISTS [${User.TABLE_NAME}](
    [${User.COLUMN_ID}] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [${User.COLUMN_USER_NAME}] TEXT NOT NULL,
    [${User.COLUMN_PASSWORD}] TEXT NOT NULL,
    [${User.COLUMN_EMAIL}] TEXT NOT NULL,
    [${User.COLUMN_CREATION_TIME}] TEXT NOT NULL,
    [${User.COLUMN_INFORMATION}] TEXT DEFAULT NULL);
    """;

    this._database = await openDatabase(path, version: version, onCreate:(Database db, int version) async{
      await db.execute(sql);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async{
      await db.execute("DROP TABLE IF EXISTS [${User.TABLE_NAME}]");
      await db.execute(sql);
    }, onOpen: (Database db) async{
      await db.execute(sql);
    });
  }

  Future<int> delete(int id) async => await this._database.delete(User.TABLE_NAME, where: "${User.COLUMN_ID} = ?", whereArgs: [id]);

  Future deleteAll(List<int> ids) async{
    final batch = this._database.batch();
    for(final id in ids){
      batch.delete(User.TABLE_NAME, where: "${User.COLUMN_ID} = ?", whereArgs: [id]);
    }
    await batch.commit(noResult: true);
  }

  Future<int> update(User user) async => this._database.update(User.TABLE_NAME, user.toMap(), where: "${User.COLUMN_ID} = ?", whereArgs: [user.id]);

  Future<User> insert(User user) async {
    user.id = await this._database.insert(User.TABLE_NAME, user.toMap());
    return user;
  }

  //Useless for duplicated record
  Future insertAll(List<User> users) async {
    final batch = this._database.batch();
    for(final user in users) {
      batch.insert(User.TABLE_NAME, user.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<User> select(int id) async {
    final columns = <String>[User.COLUMN_ID, User.COLUMN_USER_NAME, User.COLUMN_PASSWORD, User.COLUMN_EMAIL, User.COLUMN_CREATION_TIME, User.COLUMN_INFORMATION];
    final maps = await this._database.query(User.TABLE_NAME, columns: columns, where: "${User.COLUMN_ID} = ?", whereArgs: [id]);
    return maps.isNotEmpty ? User.fromMap(maps.first) : null;
  }

  Future<User> selectEmail(String email) async {
    final columns = <String>[User.COLUMN_ID, User.COLUMN_USER_NAME, User.COLUMN_PASSWORD, User.COLUMN_EMAIL, User.COLUMN_CREATION_TIME, User.COLUMN_INFORMATION];
    final maps = await this._database.query(User.TABLE_NAME, columns: columns, where: "${User.COLUMN_EMAIL} = ?", whereArgs: [email]);
    return maps.isNotEmpty ? User.fromMap(maps.first) : null;
  }

  Future<bool> isEmailUsed(String email) async{
    final maps = await this._database.query(User.TABLE_NAME, columns: [User.COLUMN_ID], where: "${User.COLUMN_EMAIL} = ?", whereArgs: [email], limit: 1, offset: 0,);
    return maps.isNotEmpty;
  }

  Future<bool> isUserNameUsed(String userName) async{
    final maps = await this._database.query(User.TABLE_NAME, columns: [User.COLUMN_ID], where: "${User.COLUMN_USER_NAME} = ?", whereArgs: [userName], limit: 1, offset: 0,);
    return maps.isNotEmpty;
  }

  Future<List<User>> selectAll() async {
    final columns = <String>[User.COLUMN_ID, User.COLUMN_USER_NAME, User.COLUMN_PASSWORD, User.COLUMN_EMAIL, User.COLUMN_CREATION_TIME, User.COLUMN_INFORMATION];
    final maps = await this._database.query(User.TABLE_NAME, columns: columns);
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future close() async {
    await this._database.close();
    this._database = null;
  }
}

class BookProvider{
  Database _database;
  int _version = 0;


  Future open(String path, {int version = 1}) async{
    if(this._database != null && this._version == version){
      return;
    }

    this._version = version;

    final sql = """CREATE TABLE IF NOT EXISTS [${Book.TABLE_NAME}](
    [${Book.COLUMN_ID}] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [${Book.COLUMN_NAME}] TEXT NOT NULL,
    [${Book.COLUMN_PRICE}] REAL NOT NULL,
    [${Book.COLUMN_AUTHORS}] TEXT NOT NULL,
    [${Book.COLUMN_IMAGE}] BLOB DEFAULT NULL);
    """;

    this._database = await openDatabase(path, version: version, onCreate:(Database db, int version) async{
      await db.execute(sql);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async{
      await db.execute("DROP TABLE IF EXISTS [${Book.TABLE_NAME}]");
      await db.execute(sql);
    }, onOpen: (Database db) async{
      await db.execute(sql);
    });
  }

  Future<int> delete(int id) async => await this._database.delete(Book.TABLE_NAME, where: "${Book.COLUMN_ID} = ?", whereArgs: [id]);

  Future deleteAll(List<int> ids) async{
    final batch = this._database.batch();
    for(final id in ids){
      batch.delete(Book.TABLE_NAME, where: "${Book.COLUMN_ID} = ?", whereArgs: [id]);
    }
    await batch.commit(noResult: true);
  }

  Future<int> update(Book book) async => this._database.update(Book.TABLE_NAME, book.toMap(), where: "${Book.COLUMN_ID} = ?", whereArgs: [book.id]);

  Future<Book> insert(Book book) async {
    book.id = await this._database.insert(Book.TABLE_NAME, book.toMap());
    return book;
  }

  Future insertAll(List<Book> books) async {
    final batch = this._database.batch();
    for(final book in books) {
      batch.insert(Book.TABLE_NAME, book.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<Book> select(int id) async {
    final columns = <String>[Book.COLUMN_ID, Book.COLUMN_NAME, Book.COLUMN_PRICE, Book.COLUMN_AUTHORS, Book.COLUMN_IMAGE];
    final maps = await this._database.query(Book.TABLE_NAME, columns: columns, where: "${Book.COLUMN_ID} = ?", whereArgs: [id]);
    return maps.isNotEmpty ? Book.fromMap(maps.first) : null;
  }

  Future<Book> selectName(String name) async {
    final columns = <String>[Book.COLUMN_ID, Book.COLUMN_NAME, Book.COLUMN_PRICE, Book.COLUMN_AUTHORS, Book.COLUMN_IMAGE];
    final maps = await this._database.query(Book.TABLE_NAME, columns: columns, where: "${Book.COLUMN_NAME} = ?", whereArgs: [name]);
    return maps.isNotEmpty ? Book.fromMap(maps.first) : null;
  }

  Future<List<Book>> selectAll() async {
    final columns = <String>[Book.COLUMN_ID, Book.COLUMN_NAME, Book.COLUMN_PRICE, Book.COLUMN_AUTHORS, Book.COLUMN_IMAGE];
    final maps = await this._database.query(Book.TABLE_NAME, columns: columns);
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  //Search for books under condition
  Future<List<Book>> searchBooks({String name = "%", String authors = "%", double minPrice, double maxPrice, int limit = -1, int offset = 0}) async {
    final columns = <String>[Book.COLUMN_ID, Book.COLUMN_NAME, Book.COLUMN_PRICE, Book.COLUMN_AUTHORS, Book.COLUMN_IMAGE];
    String where = "${Book.COLUMN_NAME} LIKE ? AND ${Book.COLUMN_AUTHORS} LIKE ?";
    List whereArgs = [name, authors];
    if(minPrice != null){
      where += " AND [${Book.COLUMN_PRICE} >= ?]";
      whereArgs.add(minPrice);
    }
    if(maxPrice != null){
      where += " AND [${Book.COLUMN_PRICE} <= ?]";
      whereArgs.add(maxPrice);
    }
    final maps = await this._database.query(Book.TABLE_NAME, columns: columns, where: where, whereArgs: whereArgs, limit: limit, offset: offset);
    return maps.map((map) => Book.fromMap(map));
  }

  Future close() async {
    await this._database.close();
    this._database = null;
  }
}

class DatabaseHelper{
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static const String DATABASE_NAME = "my_flutter_db.sqlite3";

  factory DatabaseHelper() => DatabaseHelper._instance;

  String _databaseFilePath;
  UserProvider _userProvider;
  BookProvider _bookProvider;

  Future<UserProvider> get userProvider async{
    if(this._userProvider == null){
      this._userProvider = UserProvider();

      if(this._databaseFilePath == null){
        final documentDirectory = await getApplicationDocumentsDirectory();
        this._databaseFilePath = join(documentDirectory.path, DatabaseHelper.DATABASE_NAME);
      }
      await this._userProvider.open(this._databaseFilePath, version: 2);
    }
    return this._userProvider;
  }
  Future<BookProvider> get bookProvider async{
    if(this._bookProvider == null){
      this._bookProvider = BookProvider();

      if(this._databaseFilePath == null){
        final documentDirectory = await getApplicationDocumentsDirectory();
        this._databaseFilePath = join(documentDirectory.path, DatabaseHelper.DATABASE_NAME);
      }
      await this._bookProvider.open(this._databaseFilePath, version: 2);//Must be version 2! Or no book table is created!
    }
    return this._bookProvider;
  }

  Future deleteDatabase() async {
    if(this._databaseFilePath == null){
      final documentDirectory = await getApplicationDocumentsDirectory();
      this._databaseFilePath = join(documentDirectory.path, DatabaseHelper.DATABASE_NAME);
    }
    final file = File(this._databaseFilePath);
    final fileExists = await file.exists();
    if(fileExists){
      await file.delete();
    }
  }
}
