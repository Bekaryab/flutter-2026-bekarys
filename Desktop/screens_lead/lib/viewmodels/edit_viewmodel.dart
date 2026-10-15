import '../models/student.dart';

/// ViewModel for EditScreen.
///
/// Responsibility: hold the [original] Student and an editable [draft]
/// name. Exposes [isDirty] so the View (PopScope + dialog, Level 5)
/// knows when to confirm discard. The View owns TextField/PopScope/
/// Navigator; this class holds only state and rules.
class EditViewModel {
  /// Student as it was when EditScreen opened. Never mutated.
  final Student original;

  String _draft;

  /// Starts with the original name; updated via [updateDraft].
  EditViewModel({required this.original}) : _draft = original.name;

  /// Current draft name from the TextField.
  String get draft => _draft;

  /// True when the draft differs from the original name.
  bool get isDirty => _draft != original.name;

  /// Tracks every TextField change (TextField onChanged -> here).
  void updateDraft(String value) {
    _draft = value;
  }

  // TODO(Level 3+5): decide trim/empty policy (e.g. isDirty/canSave
  // with trim) and keep draft preserved on "Keep editing".
}
