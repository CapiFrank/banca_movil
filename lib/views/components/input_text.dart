import 'package:banca_movil/utils/decorations.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String labelText;
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
    required this.labelText,
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
      style: style ?? TextStyle(color: Palette(context).primary),
      obscureText: obscureText,
      decoration: inputDefaultDecoration(
        context: context,
        labelText: labelText,
      ),
    );
  }
}
