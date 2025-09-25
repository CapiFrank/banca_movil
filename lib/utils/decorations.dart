import 'package:banca_movil/utils/palette.dart';
import 'package:flutter/material.dart';

Map<String, OutlineInputBorder> borders(BuildContext context) {
  return {
    'enabled': OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Palette(context).primary),
    ),
    'focused': OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Palette(context).primary),
    ),
    'error': OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Palette(context).errorContainer),
    ),
    'focusedError': OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Palette(context).error),
    ),
  };
}

InputDecoration inputDarkDecoration({
  required BuildContext context,
  String? labelText,
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(color: Palette(context).onSecondary),
    suffixIconColor: Palette(context).onSecondary,
    fillColor: Palette(context).secondary,
    filled: true,
    enabledBorder: borders(context)['enabled'],
    focusedBorder: borders(context)['focused'],
    errorBorder: borders(context)['error'],
    focusedErrorBorder: borders(context)['focusedError'],
  );
}

InputDecoration inputLightDecoration({
  required BuildContext context,
  String? labelText,
}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(color: Palette(context).secondary),
    suffixIconColor: Palette(context).secondary,
    fillColor: Palette(context).onSecondary,
    filled: true,
    enabledBorder: borders(context)['enabled'],
    focusedBorder: borders(context)['focused'],
    errorBorder: borders(context)['error'],
    focusedErrorBorder: borders(context)['focusedError'],
  );
}

InputDecoration inputDefaultDecoration({
  required BuildContext context,
  String? labelText,
}) {
  return InputDecoration(
    labelText: labelText,
    filled: true,
    fillColor: Palette(context).surface,
    labelStyle: TextStyle(color: Palette(context).primary),
    enabledBorder: borders(context)['enabled'],
    focusedBorder: borders(context)['focused'],
    errorBorder: borders(context)['error'],
    focusedErrorBorder: borders(context)['focusedError'],
  );
}

BoxDecoration boxDecoration({required BuildContext context}) {
  return BoxDecoration(
    color: Palette(context).onPrimary,
    borderRadius: BorderRadius.zero,
  );
}

TextStyle textStyle({required BuildContext context}) {
  return TextStyle(
    color: Palette(context).primary,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
}
