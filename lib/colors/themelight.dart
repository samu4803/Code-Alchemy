import 'package:codealchemy/backend/globalvariables.dart';
import 'package:flutter/material.dart';

class ThemeLight {
  static const primaryColor = Color.fromARGB(255, 0, 127, 212);
  static const seedColor = Colors.white;
  static const secondaryColor = Color.fromARGB(255, 11, 5, 4);
  static const backgroundColor = Color.fromARGB(255, 42, 76, 213);
  static const onBackgroundColor = Color.fromARGB(255, 26, 228, 255);
  static const surfaceVariantColor = Colors.white;
  static const textColor = Color.fromARGB(255, 146, 146, 146);
  static final colorScheme =
      ColorScheme.fromSeed(seedColor: seedColor).copyWith(
    secondary: secondaryColor,
    tertiary: seedColor,
    background: backgroundColor,
    onBackground: onBackgroundColor,
    surfaceVariant: surfaceVariantColor,
  );
  static final textTheme = TextTheme(
    titleMedium: TextStyle(
      color: secondaryColor,
      fontFamily: TextType.rubik.name,
      fontSize: 15,
    ),
    titleSmall: TextStyle(
      color: secondaryColor,
      fontFamily: TextType.rubik.name,
      fontSize: 20,
    ),
    displayMedium: TextStyle(
      color: secondaryColor,
      fontFamily: TextType.robotoMono.name,
      fontSize: 15,
    ),
    displaySmall: TextStyle(
      color: textColor,
      fontFamily: TextType.robotoMono.name,
      fontSize: 15,
    ),
  ).apply(
    bodyColor: secondaryColor,
    fontFamily: TextType.robotoMono.name,
  );
  static const elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(primaryColor),
    ),
  );
  static const iconButtonTheme = IconButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStatePropertyAll(
        secondaryColor,
      ),
    ),
  );

  static final appbarTheme = AppBarTheme(
    color: surfaceVariantColor,
    titleTextStyle: TextStyle(
      color: secondaryColor,
      fontFamily: TextType.rubik.name,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    elevation: 1,
  );
}
