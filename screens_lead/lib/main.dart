import 'package:flutter/material.dart';

import 'models/student.dart';
import 'routes/routes.dart';
import 'views/detail_screen.dart';
import 'views/edit_screen.dart';
import 'views/students_screen.dart';

void main() => runApp(const StudentsApp());

class StudentsApp extends StatelessWidget {
  const StudentsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      initialRoute: Routes.students,
      routes: {Routes.students: (_) => const StudentsScreen()},
      onGenerateRoute: (settings) {
        if (settings.name == Routes.student && settings.arguments is Student) {
          final student = settings.arguments as Student;
          return MaterialPageRoute(
            builder: (_) => DetailScreen(student: student),
          );
        }
        if (settings.name == Routes.edit && settings.arguments is Student) {
          final student = settings.arguments as Student;
          return MaterialPageRoute<String>(
            builder: (_) => EditScreen(student: student),
          );
        }
        return null;
      },
    );
  }
}
