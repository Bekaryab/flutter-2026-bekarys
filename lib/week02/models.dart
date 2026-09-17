abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({
    required this.title,
    required this.year,
  });

  String describe();

  bool get isOld => year < 2000;
}

class Author {
  final String name;
  final String? country;

  const Author({
    required this.name,
    this.country,
  });

  @override
  String toString() {
    return country == null ? name : '$name ($country)';
  }
}

enum Genre {
  craft('Craft'),
  theory('Theory'),
  unknown('Unknown');

  const Genre(this.label);

  final String label;

  static Genre fromString(String? raw) {
    if (raw == 'craft') {
      return Genre.craft;
    }

    if (raw == 'theory') {
      return Genre.theory;
    }

    return Genre.unknown;
  }
}

mixin Borrowable on LibraryItem {
  String borrowLabel() {
    return 'Borrow: $title';
  }
}

class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] as String? ?? 'Unknown title',
      year: json['year'] as int? ?? 0,
      pages: json['pages'] as int? ?? 0,
      author: Author(
        name: json['author'] as String? ?? 'Unknown',
        country: json['country'] as String?,
      ),
      genre: Genre.fromString(json['genre'] as String?),
      description: json['description'] as String?,
    );
  }

  bool get isLong {
    return pages > 400;
  }

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  @override
  String describe() {
    return '$title by ${author.name}';
  }

  @override
  String toString() {
    return '$title ($year) - ${author.name}, $pages pages';
  }
}

class Magazine extends LibraryItem {
  final int issue;

  const Magazine({
    required super.title,
    required super.year,
    required this.issue,
  });

  @override
  String describe() {
    return '$title - Issue $issue';
  }
}

class Ghost implements LibraryItem {
  @override
  final String title;

  @override
  final int year;

  const Ghost({
    required this.title,
    required this.year,
  });

  @override
  bool get isOld => year < 2000;

  @override
  String describe() {
    return 'Ghost: $title';
  }
}