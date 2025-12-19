import 'package:flutter/material.dart';
import 'package:reader_tracker/db/database_helper.dart';
import 'package:reader_tracker/models/book.dart';
import 'package:reader_tracker/utils/book_details_arguments.dart';
import 'package:flutter/foundation.dart';

import '../db/web_storage.dart';


class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: kIsWeb
              ? WebStorage.getBooks()
              : DatabaseHelper.instance.readAllBooks(),


          builder: (context, snapshot) => snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Book book = snapshot.data![index];
                    // get each books fav status

                    //print("Books: ==> ${snapshot.data![index].toString()}");
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/details',
                            arguments: BookDetailsArguments(
                                itemBook: book, isFromSavedScreen: true));
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(book.title),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              if (kIsWeb) {
                                await WebStorage.deleteBook(book.id);
                              } else {
                                await DatabaseHelper.instance.deleteBook(book.id);
                              }
                              setState(() {});
                            },
                          ),

                          leading: Image.network(
                            book.coverUrl,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.book),
                          ),


                            subtitle: Column(
                            children: [
                              Text(book.authors.join(', ')),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  book.isFavorite = !book.isFavorite;

                                  if (kIsWeb) {
                                    await WebStorage.toggleFavorite(book.id, book.isFavorite);
                                  } else {
                                    await DatabaseHelper.instance.toggleFavoriteStatus(
                                      book.id,
                                      book.isFavorite,
                                    );
                                  }

                                  setState(() {});
                                },
                                icon: Icon(
                                  book.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: book.isFavorite ? Colors.red : null,
                                ),
                                label: Text(
                                  book.isFavorite ? 'Remove Favorite' : 'Add to Favorites',
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : const Center(child: CircularProgressIndicator())),
    );
  }
}
