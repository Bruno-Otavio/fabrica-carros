import 'package:flutter/material.dart';

class LightTheme {
  final ThemeData _theme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFF3B0),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF335C67),
      surface: Color(0xFFFFF3B0),
      secondary: Color(0xFFE09F3E),
      tertiary: Color(0xFF9E2A2B),
      tertiaryFixed: Color(0xFF540B0E),
    ),
  );

  ThemeData get theme => _theme;
}
