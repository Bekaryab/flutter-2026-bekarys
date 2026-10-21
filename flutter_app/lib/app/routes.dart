import 'package:flutter/material.dart';

import '../models/event.dart';
import '../models/profile.dart';

class Routes {
  const Routes._();
  static const shell = '/', detail = '/detail', form = '/form';
}

class DetailArgs {
  const DetailArgs(
    this.event, {
    required this.onChanged,
    required this.onDeleted,
    required this.profile,
    required this.onProfile,
  });
  final Event event;
  final void Function(Event) onChanged;
  final VoidCallback onDeleted;
  final Profile profile;
  final VoidCallback onProfile;
}

class FormArgs {
  const FormArgs(this.event);
  final Event? event;
}
