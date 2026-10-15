import 'package:flutter/material.dart';

import '../viewmodels/students_viewmodel.dart';
import '../routes/routes.dart';

/// Level 1 skeleton + Level 2 navigation + Level 4 named routes.
///
/// View in MVVM: renders [StudentsViewModel.students] only.
/// Tapping a row pushes DetailScreen above the list (list stays underneath,
/// so scroll position is preserved on automatic back).
class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModel provides the list; widget holds no student data itself.
    // Plain Dart class (no ChangeNotifier), so nothing to dispose.
    final students = StudentsViewModel().students;

    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(student.name.isNotEmpty ? student.name[0] : '?'),
            ),
            title: Text(student.name),
            subtitle: Text(student.group),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(Routes.student, arguments: student);
            },
          );
        },
      ),
    );
  }
}
