# screens_lead — Practice 6: Screens That Lead to Screens

University Flutter assignment: three screens (Students list, Detail, Edit)
with direct navigation, result-return editing, named routes, and safe back
navigation. Simple MVVM using Flutter SDK and Dart only (no third-party
state-management packages).

Structure: `lib/models` (immutable `Student`), `lib/data` (eight students),
`lib/viewmodels`, `lib/views`, `lib/routes` (all route strings),
`lib/main.dart` (under 40 lines, indigo seed theme).

Levels: 1 list skeleton, 2 list-to-detail, 3 edit returns name via
`Navigator.pop`, 4 named routes with `Student` arguments, 5 `PopScope`
discard confirmation.

Run: `flutter run`. Verify: `dart format lib test`, `flutter analyze`.
