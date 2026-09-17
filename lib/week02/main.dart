import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  final library = Library();

  for (final data in rawBooks) {
    library.add(Book.fromJson(data));
  }

  library.open();

  print('=== LIBRARY CATALOGUE ===');
  print('');

  print('Every title:');
  print(library.everyTitle);
  print('');

  print('Books after 2010:');
  print(library.booksAfter2010);
  print('');

  print('Average pages:');
  print(library.averagePages);
  print('');

  print('Country of Clean Code:');
  print(library.countryOf('Clean Code'));
  print('');

  print('Author book count:');
  print(library.authorBookCount);
  print('');

  print('Distinct authors:');
  print(library.distinctAuthors);
  print('');

  print('Genres:');
  print(library.genres);
  print('');

  print('Display list:');

  for (final line in library.displayList) {
    print(line);
  }

  print('');

  final books = rawBooks.map(Book.fromJson).toList();
  final stats = statsOf(books);

  print('Stats:');
  print('Count: ${stats.count}');
  print('Average pages: ${stats.avgPages}');
  print('');

  print('Shelf states:');
  print(describe(const Empty()));

  print(describe(Ready(books)));

  print(describe(
    const Broken('Database error'),
  ));

  print('');

  print('Report:');
  print(library.report());
}