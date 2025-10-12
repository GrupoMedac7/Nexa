import 'package:flutter/material.dart';

class AppTheme {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  // Color palette for the project. It is preferable to use colors this way through the application,
  // so there's a centralized way to change colors in the future, even when overwriting light and
  // dark theme defaults.
  static Map<String, Color> palette = {
    'white': Color(0xFFFFFFFF),
    'light_purple': Color(0xFFEFE1EE),
    'dark_purple': Color(0xFF6E1FD6),
    'light_blue': Color(0xFFDAF0EE),
    'dark_blue': Color(0xFF160F29),
    'red': Color(0xFFE01515),
    'orange': Color(0xFFE08F15),
    'green': Color(0xFF3EE015),
    'grey': Color(0xFFC4C4C4),
    'black': Color(0xFF000000),
  };

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    primaryColor: palette['dark_purple'],

    scaffoldBackgroundColor: palette['light_blue'],

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: palette['dark_purple'],
        foregroundColor: palette['light_purple'],
      ),
    ),

    cardTheme: CardThemeData(
      color: palette['light_purple'],
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: palette['light_purple'],
      labelStyle: TextStyle(color: palette['dark_blue']),
      hintStyle: TextStyle(color: palette['grey']),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(palette['dark_blue']),
      trackColor: WidgetStateProperty.all(palette['light_blue']),
      trackOutlineColor: WidgetStateProperty.all(palette['dark_blue']),
      thumbIcon: WidgetStateProperty.all(
        Icon(Icons.light_mode, color: palette['light_purple']),
      ),
    ),
  );

  // WARNING: for Card and TextField widgets it is necessary to overwrite the style property so the text is visible in dark mode.
  // An example of this could be:
  //
  // Card(
  //   style: TextStyle(
  //     color: AppTheme.palette['black']
  //   ),
  // ),
  //
  // This is because Flutter treats cards as containers, so there's no textColor property or anything along those lines.
  // In the case of TextField widgets, this is because Flutter applies contrast overlays based on Brightness.dark.
  // In both cases the result is the same: given Card and TextField widgets will have a light background, they must
  // override the TextStyle color for the text to be readable.
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    primaryColor: palette['dark_purple'],

    scaffoldBackgroundColor: palette['dark_blue'],

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: palette['dark_purple'],
        foregroundColor: palette['light_purple'],
      ),
    ),

    cardTheme: CardThemeData(
      color: palette['light_purple'],
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: palette['light_purple'],
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(palette['dark_blue']),
      trackColor: WidgetStateProperty.all(palette['light_blue']),
      trackOutlineColor: WidgetStateProperty.all(palette['dark_blue']),
      thumbIcon: WidgetStateProperty.all(
        Icon(Icons.dark_mode, color: palette['light_purple']),
      ),
    ),
  );
}
