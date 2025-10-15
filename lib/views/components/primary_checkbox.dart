import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/intrinsic_size.dart';
import 'package:banca_movil/views/components/square_avatar.dart';
import 'package:flutter/material.dart';

class PrimaryCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  final String labelText;
  const PrimaryCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.labelText,
  });
  @override
  Widget build(BuildContext context) {
    return IntrinsicSize(
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SquareAvatar(
              size: 19,
              border: Border.all(
                color: Palette(context).primary.withValues(alpha: 0.2),
              ),
              color: value
                  ? Palette(context).primary
                  : Palette(context).surface,
              child: value
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: Palette(context).onPrimary,
                      fontWeight: FontWeight.bold,
                    )
                  : null,
            ),
            SizedBox(width: 4),
            Text(labelText, style: TextStyle(fontWeight: FontWeight.w100)),
          ],
        ),
      ),
    );
  }
}
