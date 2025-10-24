import 'package:flutter/material.dart';

enum IconPosition { top, bottom, right, left }

class IconText extends StatelessWidget {
  final Widget icon;
  final Widget label;
  final VoidCallback onPressed;
  final IconPosition position;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;

  const IconText({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.position = IconPosition.right,
    this.padding = const EdgeInsets.all(5),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Para posiciones verticales usamos Column
    if (position == IconPosition.top || position == IconPosition.bottom) {
      final children = position == IconPosition.top
          ? [icon, const SizedBox(height: 4), label]
          : [label, const SizedBox(height: 4), icon];

      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: padding,
          shape: const RoundedRectangleBorder(),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      );
    }

    // Para posiciones horizontales usamos TextButton.icon
    final iconAlignment = position == IconPosition.left
        ? IconAlignment.start
        : IconAlignment.end;

    return TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      iconAlignment: iconAlignment,
      style: TextButton.styleFrom(
        padding: padding,
        shape: borderRadius != null
            ? RoundedRectangleBorder(borderRadius: borderRadius!)
            : const RoundedRectangleBorder(),
      ),
    );
  }
}
