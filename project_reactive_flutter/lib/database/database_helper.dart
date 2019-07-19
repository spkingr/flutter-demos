import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'data_class.dart';

class BookProvider{
  Database _database;
  int _version = 0;
  bool _isClosed = false;

  bool get isClosed => this._isClosed || this._database == null;

  Future open(String path, {int version = 1}) async{
    if(this._database != null && this._version == version){
      return;
    }

    this._version = version;

    final sql = """CREATE TABLE IF NOT EXISTS [${Book.TABLE_NAME}](
    [${Book.COLUMN_ID}] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [${Book.COLUMN_NAME}] TEXT NOT NULL UNIQUE,
    [${Book.COLUMN_PRICE}] REAL NOT NULL,
    [${Book.COLUMN_AUTHORS}] TEXT NOT NULL,
    [${Book.COLUMN_DESCRIPTION}] TEXT NOT NULL DEFAULT "",
    [${Book.COLUMN_IMAGE}] BLOB DEFAULT NULL);
    """;

    this._database = await openDatabase(path, version: version, onCreate:(Database db, int version) async{
      await db.execute(sql);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async{
      await db.execute("DROP TABLE IF EXISTS [${Book.TABLE_NAME}]");
      await db.execute(sql);
    }, onDowngrade: (Database db, int oldVersion, int newVersion) async{
      await db.execute("DROP TABLE IF EXISTS [${Book.TABLE_NAME}]");
      await db.execute(sql);
    });

    print("_____________________________________________this.database == null ? ${this._database}");

    this._isClosed = false;
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
    final columns = <String>[Book.COLUMN_ID, Book.COLUMN_NAME, Book.COLUMN_PRICE, Book.COLUMN_AUTHORS, Book.COLUMN_DESCRIPTION, Book.COLUMN_IMAGE];
    final maps = await this._database.query(Book.TABLE_NAME, columns: columns, where: "${Book.COLUMN_ID} = ?", whereArgs: [id]);
    return maps.isNotEmpty ? Book.fromMap(maps.first) : null;
  }

  Future<Book> selectName(String name) async {
    final columns = <String>[Book.COLUMN_ID, Book.COLUMN_NAME, Book.COLUMN_PRICE, Book.COLUMN_AUTHORS, Book.COLUMN_DESCRIPTION, Book.COLUMN_IMAGE];
    final maps = await this._database.query(Book.TABLE_NAME, columns: columns, where: "${Book.COLUMN_NAME} = ?", whereArgs: [name]);
    return maps.isNotEmpty ? Book.fromMap(maps.first) : null;
  }

  Future<List<Book>> selectAll() async {
    final columns = <String>[Book.COLUMN_ID, Book.COLUMN_NAME, Book.COLUMN_PRICE, Book.COLUMN_AUTHORS, Book.COLUMN_DESCRIPTION, Book.COLUMN_IMAGE];
    final maps = await this._database.query(Book.TABLE_NAME, columns: columns);
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  //Search for books under condition
  Future<List<Book>> searchBooks({String name = "%", String authors = "%", String description = "%", double minPrice, double maxPrice, int limit = -1, int offset = 0}) async {
    final columns = <String>[Book.COLUMN_ID, Book.COLUMN_NAME, Book.COLUMN_PRICE, Book.COLUMN_AUTHORS, Book.COLUMN_DESCRIPTION, Book.COLUMN_IMAGE];
    String where = "${Book.COLUMN_NAME} LIKE ? OR ${Book.COLUMN_AUTHORS} LIKE ? OR ${Book.COLUMN_DESCRIPTION} LIKE ?";
    List whereArgs = ["%$name%", "%$authors%", "%$description%"];
    if(minPrice != null){
      where += " AND [${Book.COLUMN_PRICE} >= ?]";
      whereArgs.add(minPrice);
    }
    if(maxPrice != null){
      where += " AND [${Book.COLUMN_PRICE} <= ?]";
      whereArgs.add(maxPrice);
    }
    final maps = await this._database.query(Book.TABLE_NAME, columns: columns, where: where, whereArgs: whereArgs, limit: limit, offset: offset);
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  Future close() async {
    await this._database.close();
    this._database = null;
    this._isClosed = true;
  }
}

class DatabaseHelper{
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static const String DATABASE_NAME = "flutter.sqlite3";

  factory DatabaseHelper() => DatabaseHelper._instance;

  String _databaseFilePath;
  BookProvider _bookProvider;

  Future<BookProvider> get bookProvider async{
    final int version = 2;
    if(this._bookProvider == null){
      this._bookProvider = BookProvider();

      if(this._databaseFilePath == null){
        final documentDirectory = await getApplicationDocumentsDirectory();
        this._databaseFilePath = join(documentDirectory.path, DatabaseHelper.DATABASE_NAME);
      }
      await this._bookProvider.open(this._databaseFilePath, version: version);
    }else if(this._bookProvider.isClosed){
      await this._bookProvider.open(this._databaseFilePath, version: version);
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
