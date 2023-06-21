// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class GalleryThemeData {
  static const darkGreenBorderColor = Color(0xFF366d54);
  static const darkSelectedColor = Color(0xff242424);

  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;
  static const _lightSelectedColor = Color(0XFFE8E8E8);

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData = themeData(lightColorScheme, _lightFocusColor, _lightSelectedColor, true);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor, darkSelectedColor, false);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor, Color selectedColor, bool isLight) {
    // Color getColor1(Set<MaterialState> states) {
    //   const Set<MaterialState> interactiveStates = <MaterialState>{
    //     MaterialState.pressed,
    //     MaterialState.hovered,
    //     MaterialState.focused,
    //     MaterialState.selected,
    //   };
    //   if (states.any(interactiveStates.contains)) {
    //     return Colors.black;
    //   }
    //   return Colors.white;
    // }

    // Color getColor2(Set<MaterialState> states) {
    //   const Set<MaterialState> interactiveStates = <MaterialState>{
    //     MaterialState.pressed,
    //     MaterialState.hovered,
    //     MaterialState.focused,
    //     MaterialState.selected,
    //   };
    //   if (states.any(interactiveStates.contains)) {
    //     return Colors.white;
    //   }
    //   return Colors.black;
    // }

    return ThemeData(
      colorScheme: colorScheme,
      // textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(color: colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      listTileTheme: isLight
          ? ListTileThemeData(
              selectedTileColor: selectedColor,
            )
          : ListTileThemeData(
              selectedTileColor: selectedColor,
              selectedColor: colorScheme.primary,
              iconColor: const Color(0xFF979797),
              textColor: const Color(0xFF979797),
            ),
      focusColor: focusColor,
      dividerColor: colorScheme.primary.withOpacity(0.2),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
      ),
      datePickerTheme: const DatePickerThemeData(
        headerForegroundColor: Colors.white,
        // headerHeadlineStyle: TextStyle(color: Colors.white),
        // headerHelpStyle: TextStyle(color: Colors.white),
      ),
      popupMenuTheme: isLight
          ? null
          : const PopupMenuThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                side: BorderSide(color: darkGreenBorderColor),
              ),
            ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: isLight
            ? null
            : const CircleBorder(
                side: BorderSide(color: darkGreenBorderColor),
              ),
      ),
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Colors.black,
    primaryContainer: Color(0xFFEFF3F3),
    secondary: Colors.white,
    secondaryContainer: Colors.white,
    background: Colors.white,
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: Colors.white,
    onSecondary: Color(0xFF322942),
    onSurface: Colors.black,
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    // primary: Color(0xFFFF8383),
    primary: Colors.white,
    primaryContainer: Color(0xFF242424),
    secondary: Color(0xFF1A1A1A),
    secondaryContainer: Color(0xFF451B6F),
    background: Color(0xFF1A1A1A),
    surface: Color(0xFF1F1929),
    onBackground: Colors.yellow,
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: Color(0xFF1A1A1A),
    onSecondary: Color(0xFFFAFBFB),
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

// static final TextTheme _textTheme = TextTheme(
//   headlineMedium: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 20.0),
//   bodySmall: GoogleFonts.oswald(fontWeight: _semiBold, fontSize: 16.0),
//   headlineSmall: GoogleFonts.oswald(fontWeight: _medium, fontSize: 16.0),
//   titleMedium: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 16.0),
//   labelSmall: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 12.0),
//   bodyLarge: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 14.0),
//   titleSmall: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 14.0),
//   bodyMedium: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 16.0),
//   titleLarge: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 16.0),
//   labelLarge: GoogleFonts.montserrat(fontWeight: _semiBold, fontSize: 14.0),
// );
}
