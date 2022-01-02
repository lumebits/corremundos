import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Map<int, Color> corremundosColor = {
  50: const Color.fromRGBO(255, 88, 101, .1),
  100: const Color.fromRGBO(255, 88, 101, .2),
  200: const Color.fromRGBO(255, 88, 101, .3),
  300: const Color.fromRGBO(255, 88, 101, .4),
  400: const Color.fromRGBO(255, 88, 101, .5),
  500: const Color.fromRGBO(255, 88, 101, .6),
  600: const Color.fromRGBO(255, 88, 101, .7),
  700: const Color.fromRGBO(255, 88, 101, .8),
  800: const Color.fromRGBO(255, 88, 101, .9),
  900: const Color.fromRGBO(255, 88, 101, 1),
};

final theme = ThemeData(
  primaryColor: MaterialColor(0xFF5A17EE, corremundosColor),
  fontFamily: GoogleFonts.montserrat().fontFamily,
  inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  )),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: MaterialColor(0xFF5A17EE, corremundosColor),
    accentColor: corremundosColor[900],
  ).copyWith(secondary: MaterialColor(0xFF5A17EE, corremundosColor)),
);
