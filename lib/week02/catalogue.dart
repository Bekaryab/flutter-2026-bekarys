import 'models.dart';

class Library {
  final List<LibraryItem> items = [];

  late final DateTime openedAt;

  String? _cachedReport;

  void add(LibraryItem item) {
    items.add(item);
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }

    return null;
  }

  String countryOf(String title) {
    return findByTitle(title)?.author.country ?? 'unknown';
  }

  void open() {
    openedAt = DateTime.now();
  }

  String report() {
    return _cachedReport ??= items
        .map((item) => item.describe())
        .join('\n');
  }

  List<String> get everyTitle {
    return items.map((item) => item.title).toList();
  }

  List<Book> get booksAfter2010 {
    return items
        .whereType<Book>()
        .where((book) => book.year > 2010)
        .toList();
  }

  double get averagePages {
    final books = items.whereType<Book>().toList();

    if (books.isEmpty) {
      return 0;
    }

    // fold is used because we need one total value.
    // reduce would fail when the list is empty.
    final total = books.fold<int>(
      0,
      (sum, book) => sum + book.pages,
    );

    return total / books.length;
  }

  Map<String, int> get authorBookCount {
    return items
        .whereType<Book>()
        .map((book) => book.author.name)
        .fold<Map<String, int>>(
          {},
          (result, author) {
            result[author] = (result[author] ?? 0) + 1;
            return result;
          },
        );
  }

  Set<String> get distinctAuthors {
    return items
        .whereType<Book>()
        .map((book) => book.author.name)
        .toSet();
  }

  Set<Genre> get genres {
    return items
        .whereType<Book>()
        .map((book) => book.genre)
        .toSet();
  }

  List<String> get displayList => [
        'CATALOGUE',
        ...items.whereType<Book>().map(
              (book) => '${book.title} (${book.year})',
            ),
        ...distinctAuthors,
        if (items.whereType<Book>().any((book) => book.pages == 0))
          '(incomplete data)',
      ];
}