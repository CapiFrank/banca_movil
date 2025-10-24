import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/primitives/button.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.labelText,
    required this.onPressed,
    this.decorationBuilder,
    this.textStyleBuilder,
    this.isEnabled = true,
  });

  final String labelText;
  final Function() onPressed;
  final BoxDecoration Function(ButtonState state)? decorationBuilder;
  final TextStyle Function(ButtonState state)? textStyleBuilder;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: isEnabled ? onPressed : () {},
      decorationBuilder:
          decorationBuilder ??
          (state) {
            switch (state) {
              case ButtonState.pressed:
                return BoxDecoration(
                  color: isEnabled
                      ? Palette(context).primary.withValues(alpha: 0.9)
                      : Palette(context).primary.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
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
                  color: Palette(context).primary.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
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
                  borderRadius: BorderRadius.circular(8),
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
                  color: isEnabled
                      ? Palette(context).primary
                      : Palette(context).primary.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
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
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 2, horizontal: 2),
        child: Text(labelText),
      ),
    );
  }
}
