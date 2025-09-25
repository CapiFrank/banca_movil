import 'package:banca_movil/utils/palette.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

CurvedNavigationBarItem _buildBottomNavBarItems(
  BuildContext context, {
  required String label,
  required IconData icon,
  Color? color,
}) {
  final itemColor = color ?? Palette(context).onSecondary;
  return CurvedNavigationBarItem(
    child: Icon(icon, color: itemColor),
    label: label,
    labelStyle: TextStyle(
      color: itemColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  );
}

class BottomNavBar extends StatelessWidget {
  final void Function(int)? onTap;
  final int index;
  const BottomNavBar({super.key, this.onTap, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: index,
      items: [
        _buildBottomNavBarItems(
          context,
          label: 'Inicio',
          icon: Icons.home_outlined,
        ),
        _buildBottomNavBarItems(
          context,
          label: 'Transferir',
          icon: MingCute.transfer_3_line,
        ),
        _buildBottomNavBarItems(
          context,
          label: 'Depositar',
          icon: Clarity.bank_solid,
        ),
        _buildBottomNavBarItems(
          context,
          label: 'Pagar',
          icon: FontAwesome.money_bills_solid,
        ),
      ],
      backgroundColor: Palette(context).transparent,
      color: Palette(context).primary,
      onTap: onTap,
    );
  }
}
