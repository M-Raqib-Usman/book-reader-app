import 'package:flutter/material.dart';
import 'package:reader_tracker/db/database_helper.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:reader_tracker/utils/book_details_arguments.dart';
import 'package:flutter/foundation.dart';

import '../db/web_storage.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null || route.settings.arguments == null) {
      return const Scaffold(
        body: Center(
          child: Text('No book data found'),
        ),
      );
    }

    final args = route.settings.arguments as BookDetailsArguments;
    final Book book = args.itemBook;
    final bool isFromSavedScreen = args.isFromSavedScreen;

    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // 📘 Book Cover
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  book.coverUrl,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.book, size: 100),
                ),
              ),

              // 📄 Book Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(book.title, style: theme.headlineSmall),
                  Text(book.authors.join(', '),
                      style: theme.labelLarge),
                  Text('Published: ${book.publishedDate}',
                      style: theme.bodySmall),
                  Text('Page count: ${book.pageCount}',
                      style: theme.bodySmall),
                  Text('Language: ${book.language}',
                      style: theme.bodySmall),

                  const SizedBox(height: 16),

                  // 💾 SAVE BUTTON (Mobile Only)
                  if (!isFromSavedScreen)
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          if (kIsWeb) {
                            await WebStorage.saveBook(book);
                          } else {
                            await DatabaseHelper.instance.insert(book);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Book Saved')),
                          );
                        } catch (e) {
                          debugPrint('Save error: $e');
                        }
                      },

                      child: const Text('Save'),
                    ),

                  const SizedBox(height: 12),

                  // ❤️ FAVORITE BUTTON (Mobile Only)
                  if (!kIsWeb)
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          if (kIsWeb) {
                            await WebStorage.saveBook(book);
                          } else {
                            await DatabaseHelper.instance.insert(book);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Book Saved')),
                          );
                        } catch (e) {
                          debugPrint('Save error: $e');
                        }
                      },

                      icon: Icon(
                        book.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                        book.isFavorite ? Colors.red : null,
                      ),
                      label: Text(
                        book.isFavorite
                            ? 'Remove Favorite'
                            : 'Add to Favorites',
                      ),
                    ),

                  const SizedBox(height: 20),

                  // 📝 Description
                  Text('Description', style: theme.titleMedium),
                  const SizedBox(height: 8),

                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary,
                      ),
                    ),
                    child: Text(book.description),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
