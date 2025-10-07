import 'package:flutter/material.dart';
import 'package:banca_movil/utils/palette.dart';

class CategorizeItem extends StatelessWidget {
  final String? title;
  final String? value;
  final Widget? child;
  final bool isSelected;
  final VoidCallback? onPressed;

  /// Colores
  final Color? activeColor;
  final Color? hoverColor;
  final Color? focusColor;
  final Color? baseColor;

  /// Estilos
  final double valueFontSize;
  final double borderWidth;
  final Duration animationDuration;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const CategorizeItem({
    super.key,
    required this.isSelected,
    this.child,
    this.title,
    this.value,
    this.onPressed,
    this.activeColor,
    this.hoverColor,
    this.focusColor,
    this.baseColor,
    this.valueFontSize = 20.0,
    this.borderWidth = 2.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.padding,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Palette(context);

    final effectiveActive = activeColor ?? palette.secondary;
    final effectiveHover = hoverColor ?? palette.primary;
    final effectiveFocus = focusColor ?? palette.primary;
    final effectiveBase = baseColor ?? palette.primary;

    final backgroundColor = isSelected
        ? effectiveActive.withValues(alpha: 0.8)
        : effectiveBase.withValues(alpha: 0.08);

    final textColor = isSelected ? effectiveActive : effectiveBase;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          hoverColor: effectiveHover.withValues(alpha: 0.1),
          focusColor: effectiveFocus.withValues(alpha: 0.15),
          splashColor: effectiveFocus.withValues(alpha: 0.2),
          highlightColor: effectiveFocus.withValues(alpha: 0.1),
          onTap: onPressed,
          child: AnimatedContainer(
            duration: animationDuration,
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child ?? _buildDefaultContent(textColor),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultContent(Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null && title!.isNotEmpty)
          Text(
            title!,
            style: TextStyle(
              color: textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        if (title != null && title!.isNotEmpty) const SizedBox(height: 4),
        if (value != null && value!.isNotEmpty)
          Text(
            value!,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
      ],
    );
  }
}
