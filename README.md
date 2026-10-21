# Qadam Events

Qadam Events is a Material 3 Flutter coursework app for discovering campus and technology events. It is intentionally an in-memory demonstration: the app starts with twelve seed events, supports event discovery, details, registration, create/edit/delete, favourites, profile settings, themes, and reset, and does not use a network service or local persistence.

## Setup and run

The project requires Flutter 3.47.3 or a compatible SDK with Dart 3.13.3.

```bash
cd flutter_app
flutter pub get
flutter run
```

Useful checks:

```bash
dart format .
flutter analyze
flutter test
```

## Screenshots

Screenshots were not captured in this environment because no Android emulator or physical Android device was available. The connected macOS and Chrome targets can be used to capture the required views after launching the app:

- Phone light theme: capture the Events tab after `flutter run -d chrome` with a narrow window.
- Phone dark theme: choose Dark in Profile, then capture the same narrow layout.
- Tablet grid: resize Chrome to at least 600 px wide and capture the Events tab grid.

## Decisions

The shared event list and Profile live in `HomeShell`'s `State`, satisfying the rubric while keeping tabs focused on rendering and callbacks. Detail receives callbacks because it edits shell-owned state, while the form returns an `Event` so the shell can apply a create or edit result after typed navigation. The grid uses `LayoutBuilder` and calculates columns from available width so cells do not exceed the coursework limit. `PopScope` compares all editable form values with the opening snapshot, including category, mode, date/time, and capacity. Event data resets to fresh seed values when the Drawer reset action is confirmed or the process restarts. The form keeps controllers and focus nodes in its State and uses a one-second in-memory save simulation. With week 9 tools, the route and shell wiring could later be replaced by a typed routing package, but the current version deliberately uses one Navigator and the Flutter SDK only.
