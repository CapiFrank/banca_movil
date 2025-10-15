import 'package:banca_movil/utils/palette.dart';
import 'package:flutter/material.dart';

class SquareAvatar extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double size;
  final BoxBorder? border;
  const SquareAvatar({
    super.key,
    this.child,
    this.color,
    this.size = 38,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color ?? Palette(context).primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(size * 0.2632),
        border: border,
      ),
      child: Center(child: child),
    );
  }
}
