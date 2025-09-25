import 'package:banca_movil/utils/palette.dart';
import 'package:flutter/material.dart';

class CategorizeItem extends StatelessWidget {
  final String? title;
  final String? value;
  final Widget? child;
  final bool isSelected;
  final VoidCallback? onPressed;
  final Color? primaryColor;
  final Color? unselectedTextColor;
  final double valueFontSize;
  final double borderWidth;
  final Duration animationDuration;
  final EdgeInsets? padding;

  const CategorizeItem({
    super.key,
    required this.isSelected,
    this.child,
    this.title,
    this.value,
    this.onPressed,
    this.primaryColor,
    this.unselectedTextColor,
    this.valueFontSize = 20.0,
    this.borderWidth = 2.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePrimaryColor = primaryColor ?? Palette(context).primary;
    final effectiveUnselectedColor =
        unselectedTextColor ?? Palette(context).primary;

    return Expanded(
      child: AnimatedContainer(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.symmetric(horizontal: 16),
        duration: animationDuration,
        decoration: BoxDecoration(
          color: isSelected
              ? effectivePrimaryColor
              : effectivePrimaryColor.withValues(alpha: 0.6),
          border: Border.all(color: effectivePrimaryColor, width: borderWidth),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(),
            padding: padding ?? const EdgeInsets.all(0),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onPressed,
          child:
              child ??
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title ?? '',
                    style: TextStyle(
                      color: isSelected
                          ? effectivePrimaryColor
                          : effectiveUnselectedColor,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value ?? '',
                    style: TextStyle(
                      fontSize: valueFontSize,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? effectivePrimaryColor
                          : effectiveUnselectedColor,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
