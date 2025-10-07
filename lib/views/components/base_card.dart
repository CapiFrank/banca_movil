import 'package:flutter/material.dart';
import 'package:banca_movil/views/components/elevated_flex_container.dart';

class BaseCard extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final BorderRadius borderRadius;

  const BaseCard({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.margin,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 1,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedFlexContainer.horizontal(
      onTap: onTap,
      margin: margin,
      padding: padding,
      elevation: elevation,
      borderRadius: borderRadius,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Lado izquierdo
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) leading!,
              if (leading != null) const SizedBox(width: 10),
              if (title != null || subtitle != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) title!,
                      if (subtitle != null) subtitle!,
                    ],
                  ),
                ),
            ],
          ),
        ),
        // Lado derecho
        if (trailing != null) trailing!,
      ],
    );
  }
}
