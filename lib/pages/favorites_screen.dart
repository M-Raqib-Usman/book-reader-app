import 'package:flutter/material.dart';
import 'package:reader_tracker/db/database_helper.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:flutter/foundation.dart';

import '../db/web_storage.dart';


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Book>>(
        future: kIsWeb
            ? WebStorage.getFavorites()
            : DatabaseHelper.instance.getFavorites(),


        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final favBooks = snapshot.data ?? [];

          if (favBooks.isEmpty) {
            return const Center(child: Text('No favorite books found'));
          }

          return ListView.builder(
            itemCount: favBooks.length,
            itemBuilder: (context, index) {
              final book = favBooks[index];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    book.coverUrl,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.book),
                  ),


                    title: Text(book.title),
                  subtitle: Text(book.authors.join(', ')),
                  trailing:
                  const Icon(Icons.favorite, color: Colors.red),
                ),
              );
            },
          );
        },
      ));}}
