import 'package:banca_movil/utils/palette.dart';
import 'package:flutter/material.dart';

class SquareAvatar extends StatelessWidget {
  final Widget? child;
  final Color? color;
  const SquareAvatar({super.key, this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        color: color ?? Palette(context).primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
