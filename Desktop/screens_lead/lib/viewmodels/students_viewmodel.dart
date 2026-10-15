import '../data/student_data.dart';
import '../models/student.dart';

/// ViewModel for the students list.
///
/// Responsibility: expose the initial list of eight students.
/// Views render [students] and forward taps. Selection and rename
/// logic will be added in later levels (2-3) without adding
/// third-party packages. Plain Dart class is enough for now —
/// no ChangeNotifier/Provider/Riverpod/Bloc.
class StudentsViewModel {
  /// The eight students shown on StudentsScreen.
  List<Student> get students => initialStudents;

  // TODO(Level 2-3): hold a mutable copy and an update method
  // (e.g. rename at index) so Detail/Edit results refresh the list,
  // while keeping Student itself immutable.
}
