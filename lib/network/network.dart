import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:reader_tracker/models/book.dart';

class Network {
  static const String _host = 'www.googleapis.com';
  static const String _path = '/books/v1/volumes';

  Future<List<Book>> searchBooks(String query) async {
    final uri = Uri.https(
      _host,
      _path,
      {'q': query},
    );

    try {
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final Map<String, dynamic> data =
      jsonDecode(response.body) as Map<String, dynamic>;

      final items = data['items'];

      if (items == null || items is! List) {
        return [];
      }

      return items
          .map<Book>((item) =>
          Book.fromJson(item as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } catch (e) {
      throw Exception('Failed to load books');
    }
  }
}
