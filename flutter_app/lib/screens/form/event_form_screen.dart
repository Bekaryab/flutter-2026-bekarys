import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../utils/format.dart';

class EventFormScreen extends StatefulWidget {
  const EventFormScreen({this.event, super.key});
  final Event? event;
  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title,
      _location,
      _limit,
      _description,
      _dateText,
      _timeText;
  late final FocusNode _titleFocus, _locationFocus, _limitFocus;
  late EventCategory _category;
  late bool _online = false, _saving = false, _saved = false;
  late DateTime _date, _time;
  late final String _initialTitle,
      _initialLocation,
      _initialLimit,
      _initialDescription;
  late final EventCategory _initialCategory;
  late final bool _initialOnline;
  late final DateTime _initialDate, _initialTime;

  @override
  void initState() {
    super.initState();
    final event = widget.event ?? Event.empty();
    _title = TextEditingController(text: widget.event?.title);
    _location = TextEditingController(text: widget.event?.location);
    _limit = TextEditingController(text: event.limit.toString());
    _description = TextEditingController(text: widget.event?.description ?? '');
    _dateText = TextEditingController();
    _timeText = TextEditingController();
    _titleFocus = FocusNode();
    _locationFocus = FocusNode();
    _limitFocus = FocusNode();
    _category = event.category;
    _online = event.isOnline;
    _date = DateTime(event.when.year, event.when.month, event.when.day);
    _time = event.when;
    _initialTitle = _title.text;
    _initialLocation = _location.text;
    _initialLimit = _limit.text;
    _initialDescription = _description.text;
    _initialCategory = _category;
    _initialOnline = _online;
    _initialDate = _date;
    _initialTime = _time;
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _location,
      _limit,
      _description,
      _dateText,
      _timeText,
    ]) {
      c.dispose();
    }
    for (final f in [_titleFocus, _locationFocus, _limitFocus]) {
      f.dispose();
    }
    super.dispose();
  }

  bool get _dirty =>
      _title.text != _initialTitle ||
      _location.text != _initialLocation ||
      _limit.text != _initialLimit ||
      _description.text != _initialDescription ||
      _category != _initialCategory ||
      _online != _initialOnline ||
      _date != _initialDate ||
      _time.hour != _initialTime.hour ||
      _time.minute != _initialTime.minute;
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      initialDate: _date,
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_time),
    );
    if (picked != null && mounted) {
      setState(
        () => _time = DateTime(
          _date.year,
          _date.month,
          _date.day,
          picked.hour,
          picked.minute,
        ),
      );
    }
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    final combined = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );
    if (widget.event == null && !combined.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New events must be in the future.')),
      );
      return;
    }
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final original = widget.event;
    final event = Event(
      id: original?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      category: _category,
      when: combined,
      location: _location.text.trim(),
      limit: int.parse(_limit.text.trim()),
      attendees: original?.attendees ?? const [],
      isOnline: _online,
      description: _description.text.trim().isEmpty
          ? null
          : _description.text.trim(),
      isFavourite: original?.isFavourite ?? false,
    );
    _saved = true;
    Navigator.pop(context, event);
  }

  Future<bool> _confirmPop() async {
    if (!_dirty || _saved) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your unsaved changes will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    _dateText.text = formatDateTime(_date);
    _timeText.text =
        '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
    return PopScope(
      canPop: !_dirty || _saved,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || !mounted) return;
        final shouldPop = await _confirmPop();
        if (shouldPop && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.event == null ? 'Create event' : 'Edit event'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _title,
                focusNode: _titleFocus,
                maxLength: 60,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _locationFocus.requestFocus(),
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  final length = value?.trim().length ?? 0;
                  return length >= 3 && length <= 60
                      ? null
                      : 'Title must be 3–60 characters';
                },
              ),
              TextFormField(
                controller: _location,
                focusNode: _locationFocus,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _limitFocus.requestFocus(),
                decoration: InputDecoration(
                  labelText: _online ? 'Online link' : 'Location',
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  return text.isEmpty || (_online && !text.contains('://'))
                      ? (_online
                            ? 'Enter a valid link containing ://'
                            : 'Location is required')
                      : null;
                },
              ),
              TextFormField(
                controller: _limit,
                focusNode: _limitFocus,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Capacity'),
                validator: (value) {
                  final limit = int.tryParse(value?.trim() ?? '');
                  final count = widget.event?.attendeeCount ?? 0;
                  return limit == null ||
                          limit < 1 ||
                          limit > 500 ||
                          limit < count
                      ? 'Use 1–500 and do not go below attendees'
                      : null;
                },
              ),
              DropdownButtonFormField<EventCategory>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: [
                  for (final category in EventCategory.values)
                    DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _category = value);
                },
                validator: (value) =>
                    value == null ? 'Choose a category' : null,
              ),
              SwitchListTile(
                title: const Text('Online event'),
                value: _online,
                onChanged: (value) => setState(() => _online = value),
              ),
              TextFormField(
                controller: _description,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
              ),
              TextFormField(
                readOnly: true,
                controller: _dateText,
                decoration: const InputDecoration(labelText: 'Date'),
                onTap: _pickDate,
              ),
              TextFormField(
                readOnly: true,
                controller: _timeText,
                decoration: const InputDecoration(labelText: 'Time'),
                onTap: _pickTime,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_saving ? 'Saving…' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
