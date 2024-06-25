import 'package:owod_functionnalities/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const double defaultPadding = 16;
  static final lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppPalette.backgroundColor,
      chipTheme: ChipThemeData(
          color: WidgetStateProperty.all(AppPalette.backgroundColor),
          side: BorderSide.none),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(27),
        enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppPalette.borderColor, width: 3),
            borderRadius: BorderRadius.circular(13)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppPalette.borderColor, width: 4),
            borderRadius: BorderRadius.circular(15)),
        errorBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppPalette.errorColor, width: 4),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppPalette.gradient2, width: 3),
            borderRadius: BorderRadius.circular(15)),
      ));
}
