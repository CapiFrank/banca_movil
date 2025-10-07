import 'package:banca_movil/utils/palette.dart';
import 'package:flutter/material.dart';

class SelectableTabItem extends StatelessWidget {
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

  const SelectableTabItem({
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
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        focusColor: effectivePrimaryColor.withValues(alpha: 0.1),
        hoverColor: effectivePrimaryColor.withValues(alpha: 0.05),
        splashColor: effectivePrimaryColor.withValues(alpha: 0.1),
        highlightColor: effectivePrimaryColor.withValues(alpha: 0.1),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              bottom: BorderSide(
                color: isSelected ? effectivePrimaryColor : Colors.transparent,
                width: borderWidth,
              ),
            ),
          ),
          child: Center(
            child:
                child ??
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
    );
  }
}
