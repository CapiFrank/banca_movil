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
  final EdgeInsets? margin;
  final BoxDecoration? decoration;

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
    this.decoration,
    this.margin,
  });

  factory SelectableTabItem.onHeader({
    key,
    isSelected,
    child,
    title,
    value,
    onPressed,
    primaryColor,
    unselectedTextColor,
    valueFontSize = 20.0,
    borderWidth = 2.0,
    animationDuration = const Duration(milliseconds: 200),
    padding,
    margin,
  }) {
    assert(
      primaryColor != null,
      'Debe proporcionarse un primaryColor al usar onHeader factory',
    );
    return SelectableTabItem(
      key: key,
      isSelected: isSelected,
      child: child,
      title: title,
      value: value,
      onPressed: onPressed,
      primaryColor: primaryColor,
      unselectedTextColor: unselectedTextColor,
      valueFontSize: valueFontSize,
      borderWidth: borderWidth,
      animationDuration: animationDuration,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      decoration: _onHeader(
        condition: isSelected,
        color: primaryColor,
        width: borderWidth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectivePrimaryColor = primaryColor ?? Palette(context).primary;
    final effectiveUnselectedColor =
        unselectedTextColor ?? Palette(context).primary;

    return Expanded(
      child: Padding(
        padding: margin ?? EdgeInsets.all(0),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          focusColor: effectivePrimaryColor.withValues(alpha: 0.1),
          hoverColor: effectivePrimaryColor.withValues(alpha: 0.05),
          splashColor: effectivePrimaryColor.withValues(alpha: 0.1),
          highlightColor: effectivePrimaryColor.withValues(alpha: 0.1),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 4),
            decoration:
                decoration ??
                BoxDecoration(
                  color: isSelected ? Palette(context).surface : null,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Palette(context).shadow.withValues(
                          alpha: 0.2,
                        ), // Shadow color with opacity
                        offset: Offset(0, 1), // Shadow position (x, y)
                        blurRadius: 2, // Blur effect
                        spreadRadius: 0.2, // Shadow expansion
                      ),
                  ],
                ),
            child: Center(
              child:
                  child ??
                  Column(
                    mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}

BoxDecoration _onHeader({
  required bool condition,
  required Color color,
  required double width,
}) {
  return BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: condition ? color : Colors.transparent,
        width: width,
      ),
    ),
  );
}
