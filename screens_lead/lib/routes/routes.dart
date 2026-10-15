/// Central place for all route names.
///
/// All strings starting with `/` live only in this file.
/// Views reference [students], [student], and [edit] through this class.
/// The student and edit routes require a Student via RouteSettings.arguments
/// and are built in onGenerateRoute (see main.dart).
class Routes {
  const Routes._();

  /// Students list screen.
  static const String students = '/';

  /// Detail screen for one student (requires a Student argument).
  static const String student = '/student';

  /// Edit screen for one student (requires a Student argument).
  static const String edit = '/edit';
}
