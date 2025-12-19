import 'package:flutter/material.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:reader_tracker/utils/book_details_arguments.dart';

class GridViewWidget extends StatelessWidget {
  const GridViewWidget({super.key, required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        final book = books[index];
        debugPrint(book.thumbnailUrl);


        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/details',
              arguments: BookDetailsArguments(
                itemBook: book,
                isFromSavedScreen: false,
              ),
            );
          },
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: book.thumbnailUrl.isNotEmpty
                      ? Image.network(
                    book.coverUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.book,
                      size: 64,
                      color: Colors.grey,
                    ),
                  )


                      : const Icon(
                    Icons.book,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
