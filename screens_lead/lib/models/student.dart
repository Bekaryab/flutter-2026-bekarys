/// Immutable Model for a university student.
///
/// ViewModels own instances of [Student] and create updated copies
/// via [copyWith]. Views only render it and forward user actions.
/// Never mutate fields — all fields are `final`.
class Student {
  /// Full name shown in the list, detail, and edit screens.
  final String name;

  /// Group name shown in the list and detail screens.
  final String group;

  /// Email shown on the detail screen.
  final String email;

  /// Creates an immutable student.
  const Student({required this.name, required this.group, required this.email});

  /// Returns a new [Student] with the given name.
  ///
  /// Used when saving an edit. The original instance is unchanged.
  Student copyWith({String? name}) {
    return Student(name: name ?? this.name, group: group, email: email);
  }
}
