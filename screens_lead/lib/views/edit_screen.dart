import 'package:flutter/material.dart';

import '../models/student.dart';

/// Level 5 edit: safe back navigation with a discard confirmation.
///
/// View in MVVM: tracks a local [String] draft only. The Model stays
/// immutable; Save returns the draft via `Navigator.pop`, Discard and
/// clean back return null. No controller, no manual back button.
class EditScreen extends StatefulWidget {
  final Student student;

  const EditScreen({super.key, required this.student});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late String _name;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    _name = widget.student.name;
  }

  /// True when the draft differs from the original name.
  bool get _isDirty => _name != widget.student.name;

  Future<void> _confirmDiscard() async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    _dialogOpen = false;
    if (!mounted) return;
    // Only Discard leaves EditScreen, without returning the draft.
    if (discard == true) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Clean form pops immediately; dirty form is blocked for confirmation.
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _confirmDiscard();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit student')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: widget.student.name,
                ),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(_name);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
