import 'package:hive/hive.dart';
import 'package:reader_tracker/models/book.dart';

class WebStorage {
  static final _box = Hive.box('booksBox');

  static Future<void> saveBook(Book book) async {
    await _box.put(book.id, book.toJson());
  }

  static Future<List<Book>> getBooks() async {
    return _box.values
        .map((e) => Book.fromJsonDatabase(
        Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> toggleFavorite(String id, bool fav) async {
    final data = _box.get(id);
    if (data != null) {
      data['favorite'] = fav ? 1 : 0;
      await _box.put(id, data);
    }
  }
  static Future<void> deleteBook(String id) async {
    await _box.delete(id);
  }


  static Future<List<Book>> getFavorites() async {
    return _box.values
        .where((e) => e['favorite'] == 1)
        .map((e) => Book.fromJsonDatabase(
        Map<String, dynamic>.from(e)))
        .toList();
  }
}
