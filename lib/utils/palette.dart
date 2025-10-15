import 'package:flutter/material.dart';

class Palette {
  final BuildContext context;
  Palette(this.context);
  Color get error => Color(0xFFEA2831);
  Color get outline => Theme.of(context).colorScheme.outline;
  Color get outlineVariant => Theme.of(context).colorScheme.outlineVariant;
  Color get errorContainer => Theme.of(context).colorScheme.errorContainer;
  Color get primary => Color(0xFF22408A);
  //Colors.red; //Color(0xFF22408A); // Default secondary color
  Color get secondary => Color(0xFFC6D400);
  //Colors.orange; //Color(0xFFC6D400); // Default primary color
  Color get tertiary => Theme.of(context).colorScheme.tertiary;
  Color get surface => Colors.white;
  Color get shadow => Theme.of(context).colorScheme.shadow;
  Color get onError => Theme.of(context).colorScheme.onError;
  Color get onPrimary => Theme.of(context).colorScheme.onPrimary;
  Color get onSecondary => Theme.of(context).colorScheme.onSecondary;
  Color get onTertiary => Theme.of(context).colorScheme.onTertiary;
  Color get onSurface => Theme.of(context).colorScheme.onSurface;
  Color get background => Color(0xFFF6F6F8);
  Color get onBackground => Colors.black;
  Color get transparent => Colors.transparent;
  Color get primaryText => surface;
  TextTheme get textTheme => Theme.of(context).textTheme;

  ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor: primary,
    primary: primary,
    error: error,
    outline: outline,
    outlineVariant: outlineVariant,
    errorContainer: errorContainer,
    secondary: secondary,
    tertiary: tertiary,
    surface: surface,
    shadow: shadow,
    onError: onError,
    onPrimary: onPrimary,
    onSecondary: onSecondary,
    onTertiary: onTertiary,
    onSurface: onSurface,
  );

  // Colores custom
  // Color get customGray => const Color(0xFF424242);
}
