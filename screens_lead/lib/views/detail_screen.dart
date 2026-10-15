import 'package:flutter/material.dart';

import '../models/student.dart';
import '../routes/routes.dart';

/// Level 3 detail + Level 4 named routes: shows one student, opens Edit
///
/// View in MVVM: holds the displayed [Student] in [_student] (local State
/// required by the assignment for await + setState). Updates are made with
/// `copyWith`, so the Model stays immutable. No manual back button.
class DetailScreen extends StatefulWidget {
  final Student student;

  const DetailScreen({super.key, required this.student});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student = widget.student;
  }

  Future<void> _edit() async {
    final name = await Navigator.of(context)
        .pushNamed<String>(Routes.edit, arguments: _student);

    if (name == null || !mounted) return;

    setState(() {
      _student = _student.copyWith(name: name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_student.name),
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: _edit)],
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Group'),
            subtitle: Text(_student.group),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email'),
            subtitle: Text(_student.email),
          ),
        ],
      ),
    );
  }
}
