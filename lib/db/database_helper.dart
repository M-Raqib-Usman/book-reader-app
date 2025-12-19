import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('Database not supported on Web');
    }
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'books.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE books(
          id TEXT PRIMARY KEY,
          title TEXT,
          authors TEXT,
          favorite INTEGER,
          publisher TEXT,
          publishedDate TEXT,
          description TEXT,
          industryIdentifiers TEXT,
          pageCount INTEGER,
          language TEXT,
          imageLinks TEXT,
          previewLink TEXT,
          infoLink TEXT
        )
        ''');
      },
    );
  }

  Future<int> insert(Book book) async {
    final db = await database;
    return db.insert('books', book.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Book>> readAllBooks() async {
    final db = await database;
    final res = await db.query('books');
    return res.map(Book.fromJsonDatabase).toList();
  }

  Future<List<Book>> getFavorites() async {
    final db = await database;
    final res = await db.query('books', where: 'favorite = 1');
    return res.map(Book.fromJsonDatabase).toList();
  }

  Future<void> deleteBook(String id) async {
    final db = await database;
    await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> toggleFavoriteStatus(String id, bool fav) async {
    final db = await database;
    await db.update(
      'books',
      {'favorite': fav ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
