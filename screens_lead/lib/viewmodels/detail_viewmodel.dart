import '../models/student.dart';

/// ViewModel for DetailScreen.
///
/// Responsibility: hold the selected [student] and create an updated
/// copy when a new name returns from EditScreen. The View awaits the
/// `Navigator` result, checks for null/mounted, then calls into here
/// and refreshes with `setState` (Level 3).
class DetailViewModel {
  /// Currently displayed student.
  Student student;

  /// Holds the selected student passed via constructor/arguments.
  DetailViewModel({required this.student});

  /// Creates a new Student with [newName], leaving group/email unchanged.
  Student updatedWithName(String newName) {
    return student.copyWith(name: newName);
  }

  // TODO(Level 3): add applyName(newName) that replaces [student] with
  // updatedWithName(newName) so the View can setState once.
}
