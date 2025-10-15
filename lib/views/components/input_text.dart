import 'package:banca_movil/utils/decorations.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? labelText;
  final String? hintText;
  final String? prefixText;
  final bool obscureText;
  final InputDecoration? decoration;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatters;
  final Color? cursorColor;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  const InputText({
    super.key,
    this.labelText,
    this.hintText,
    this.textEditingController,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.decoration,
    this.style,
    this.inputFormatters,
    this.cursorColor,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onSubmitted: onFieldSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      onChanged: onChanged,
      cursorColor: cursorColor ?? Palette(context).primary,
      style:
          style ??
          TextStyle(
            color: Palette(context).shadow.withValues(alpha: 0.6),
            fontWeight: FontWeight.bold,
          ),
      obscureText: obscureText,
      decoration: (decoration ?? inputDefaultDecoration(context: context))
          .copyWith(
            labelText: labelText,
            hintText: hintText,
            prefixText: prefixText,
          ),
    );
  }
}

/// Formatter que mantiene "CR" al inicio y permite solo números después
class PrefixInputFormatter extends TextInputFormatter {
  final String prefix;

  PrefixInputFormatter({required this.prefix});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Siempre asegurar que empieza con CR
    String text = newValue.text;
    if (!text.startsWith(prefix)) {
      text = prefix + text.replaceAll(prefix, '');
    }

    // Solo permitir números después de CR
    final numbers = text
        .substring(prefix.length)
        .replaceAll(RegExp(r'[^0-9]'), '');
    final newText = prefix + numbers;

    // Mantener cursor al final
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class NumberInputFormatter extends TextInputFormatter {
  final int decimalRange;

  NumberInputFormatter({this.decimalRange = 2})
    : assert(decimalRange >= 0, "decimalRange debe ser >= 0");

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Separamos parte entera y decimal
    List<String> parts = newText.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Limitar decimales
    if (decimalRange > 0 && decimalPart.length > decimalRange) {
      decimalPart = decimalPart.substring(0, decimalRange);
    }

    // Agregamos separadores de miles
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      int positionFromEnd = integerPart.length - i;
      formattedInteger += integerPart[i];
      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
        formattedInteger += ',';
      }
    }

    // Construimos el número final
    String formatted = formattedInteger;
    if (decimalPart.isNotEmpty) {
      formatted += '.$decimalPart';
    } else {
      if (newText.endsWith('.')) {
        formatted += '.';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
