import 'package:flutter/material.dart';

import '../models/event.dart';
import '../screens/shell/home_shell.dart';
import '../screens/details/event_details_screen.dart';
import '../screens/form/event_form_screen.dart';
import '../screens/common/not_found_screen.dart';
import 'routes.dart';

class QadamApp extends StatefulWidget {
  const QadamApp({super.key});
  @override
  State<QadamApp> createState() => _QadamAppState();
}

class _QadamAppState extends State<QadamApp> {
  ThemeMode _themeMode = ThemeMode.system;
  void _setTheme(ThemeMode mode) => setState(() => _themeMode = mode);
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Qadam Events',
    themeMode: _themeMode,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: ColorScheme.light().primary),
      useMaterial3: true,
    ),
    darkTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorScheme.light().primary,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    ),
    initialRoute: Routes.shell,
    routes: {
      Routes.shell: (_) =>
          HomeShell(themeMode: _themeMode, onThemeChanged: _setTheme),
    },
    onGenerateRoute: (settings) {
      if (settings.name == Routes.detail && settings.arguments is DetailArgs) {
        return MaterialPageRoute(
          builder: (_) =>
              EventDetailsScreen(args: settings.arguments as DetailArgs),
        );
      }
      if (settings.name == Routes.form && settings.arguments is FormArgs) {
        return MaterialPageRoute<Event>(
          builder: (_) =>
              EventFormScreen(event: (settings.arguments as FormArgs).event),
        );
      }
      return null;
    },
    onUnknownRoute: (_) =>
        MaterialPageRoute(builder: (_) => const NotFoundScreen()),
  );
}
