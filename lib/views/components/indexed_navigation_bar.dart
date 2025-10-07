import 'dart:io';
import 'package:flutter/material.dart';
import 'package:banca_movil/utils/palette.dart';

/// Clase para contener la información de cada ítem
class BottomNavItemData {
  final String label;
  final IconData icon;
  final Color? color;

  BottomNavItemData({required this.label, required this.icon, this.color});
}

/// Widget base universal que recibe una lista de elementos y asigna índice automáticamente
class IndexedNavigationBar extends StatelessWidget {
  final List<BottomNavItemData> items;
  final int selectedIndex;
  final void Function(int index)? onTap;
  final Color? backgroundColor;

  const IndexedNavigationBar({
    super.key,
    required this.items,
    this.selectedIndex = 0,
    this.onTap,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final heigth = Platform.isAndroid ? 70.0 : 80.0;

    return Material(
      color: backgroundColor,
      child: Container(
        height: heigth,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Palette(context).shadow.withValues(alpha: 0.1),
              width: 1.2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == selectedIndex;
            final colorIcon = item.color ?? Palette(context).primary;
            final selectedColor = isSelected
                ? colorIcon
                : Palette(context).onBackground.withValues(alpha: 0.5);

            return Expanded(
              child: Center(
                child: IntrinsicHeight(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    hoverColor: colorIcon.withValues(alpha: 0.05),
                    focusColor: colorIcon.withValues(alpha: 0.2),
                    highlightColor: colorIcon.withValues(alpha: 0.1),
                    splashColor: colorIcon.withValues(alpha: 0.1),
                    onTap: () => onTap?.call(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorIcon.withValues(alpha: 0.1)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            size: 24,
                            color: selectedColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          Text(
                            item.label,
                            style: Palette(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: selectedColor,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
