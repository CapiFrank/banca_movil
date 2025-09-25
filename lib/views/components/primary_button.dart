import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/button.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.labelText,
    required this.onPressed,
    this.decorationBuilder,
    this.textStyleBuilder,
  });

  final String labelText;
  final Function() onPressed;
  final BoxDecoration Function(ButtonState state)? decorationBuilder;
  final TextStyle Function(ButtonState state)? textStyleBuilder;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      decorationBuilder:
          decorationBuilder ??
          (state) {
            switch (state) {
              case ButtonState.pressed:
                return BoxDecoration(
                  color: Palette(context).primary.withValues(alpha: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Palette(context).shadow.withValues(alpha: 0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                );
              case ButtonState.hover:
                return BoxDecoration(
                  color: Palette(context).primary.withValues(alpha: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Palette(context).shadow.withValues(alpha: 0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                );
              case ButtonState.focused:
                return BoxDecoration(
                  color: Palette(context).primary.withValues(alpha: 0.7),
                  boxShadow: [
                    BoxShadow(
                      color: Palette(context).shadow.withValues(alpha: 0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                );
              case ButtonState.normal:
                return BoxDecoration(
                  color: Palette(context).primary,
                  boxShadow: [
                    BoxShadow(
                      color: Palette(context).shadow.withValues(alpha: 0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                );
            }
          },
      textStyleBuilder:
          textStyleBuilder ??
          (state) => TextStyle(
            color: Palette(context).onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
      child: Text(labelText),
    );
  }
}
