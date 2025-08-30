import 'package:codealchemy/backend/globalvariables.dart';
import 'package:flutter/material.dart';

class ThemeDark {
  static const primaryColor = Color.fromARGB(255, 0, 127, 212);
  static const seedColor = Color.fromARGB(255, 30, 30, 30);
  static const secondaryColor = Colors.white;
  static const backgroundColor = Color.fromARGB(255, 0, 203, 230);
  static const onBackgroundColor = Color.fromARGB(255, 42, 76, 213);
  static const surfaceVariantColor = Color.fromARGB(255, 0, 45, 51);
  static const textColor = Color.fromARGB(255, 146, 146, 146);
  static final colorScheme =
      ColorScheme.fromSeed(seedColor: seedColor).copyWith(
    secondary: secondaryColor,
    tertiary: seedColor,
    background: backgroundColor,
    onBackground: onBackgroundColor,
    surfaceVariant: surfaceVariantColor,
  );

  static const iconButtonTheme = IconButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStatePropertyAll(
        secondaryColor,
      ),
    ),
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
  static const elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(primaryColor),
    ),
  );
}
