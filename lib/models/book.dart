import 'dart:convert';

class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String description;
  final Map<String, String> industryIdentifiers;
  final int pageCount;
  final String language;
  final Map<String, String> imageLinks;
  final String previewLink;
  final String infoLink;
  bool isFavorite;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.industryIdentifiers,
    required this.pageCount,
    required this.language,
    required this.imageLinks,
    required this.previewLink,
    required this.infoLink,
    this.isFavorite = false,
  });

  /// ✅ Safe HTTPS thumbnail for Flutter Web
  String get thumbnailUrl {
    final raw =
        imageLinks['thumbnail'] ?? imageLinks['smallThumbnail'];

    if (raw == null || raw.isEmpty) return '';

    // Force HTTPS
    final httpsUrl = raw.replaceFirst('http://', 'https://');

    // Google Books sometimes needs zoom=0 or 1 explicitly
    if (!httpsUrl.contains('zoom=')) {
      return '$httpsUrl&zoom=1';
    }

    return httpsUrl;
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo =
        json['volumeInfo'] as Map<String, dynamic>? ?? {};

    return Book(
      id: json['id']?.toString() ?? '',
      title: volumeInfo['title']?.toString() ?? 'Unknown title',
      authors: (volumeInfo['authors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      publisher: volumeInfo['publisher']?.toString() ?? '',
      publishedDate: volumeInfo['publishedDate']?.toString() ?? '',
      description: volumeInfo['description']?.toString() ?? '',
      industryIdentifiers: {
        for (final item
        in (volumeInfo['industryIdentifiers'] as List<dynamic>? ??
            []))
          item['type']?.toString() ?? '':
          item['identifier']?.toString() ?? '',
      },
      pageCount:
      (volumeInfo['pageCount'] is int) ? volumeInfo['pageCount'] : 0,
      language: volumeInfo['language']?.toString() ?? '',
      imageLinks:
      (volumeInfo['imageLinks'] as Map<String, dynamic>?)
          ?.map((k, v) =>
          MapEntry(k.toString(), v.toString())) ??
          {},
      previewLink: volumeInfo['previewLink']?.toString() ?? '',
      infoLink: volumeInfo['infoLink']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': jsonEncode(authors),
      'publisher': publisher,
      'publishedDate': publishedDate,
      'description': description,
      'favorite': isFavorite ? 1 : 0,
      'industryIdentifiers': jsonEncode(industryIdentifiers),
      'pageCount': pageCount,
      'language': language,
      'imageLinks': jsonEncode(imageLinks),
      'previewLink': previewLink,
      'infoLink': infoLink,
    };
  }
  String get coverUrl {
    // 1️⃣ Try Google Books (works on mobile)
    final google =
        imageLinks['thumbnail'] ?? imageLinks['smallThumbnail'];

    // 2️⃣ Extract ISBN for Open Library
    final isbn = industryIdentifiers['ISBN_13'] ??
        industryIdentifiers['ISBN_10'];

    // 3️⃣ Web fallback (Open Library supports CORS)
    if (isbn != null && isbn.isNotEmpty) {
      return 'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg';
    }

    // 4️⃣ Mobile fallback
    if (google != null && google.isNotEmpty) {
      return google.replaceFirst('http://', 'https://');
    }

    return '';
  }


  factory Book.fromJsonDatabase(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      authors: List<String>.from(jsonDecode(json['authors'])),
      publisher: json['publisher'] ?? '',
      publishedDate: json['publishedDate'] ?? '',
      description: json['description'] ?? '',
      industryIdentifiers:
      Map<String, String>.from(jsonDecode(json['industryIdentifiers'])),
      pageCount: json['pageCount'] ?? 0,
      language: json['language'] ?? '',
      imageLinks:
      Map<String, String>.from(jsonDecode(json['imageLinks'])),
      previewLink: json['previewLink'] ?? '',
      infoLink: json['infoLink'] ?? '',
      isFavorite: json['favorite'] == 1,
    );
  }
}

