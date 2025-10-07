import 'package:banca_movil/views/components/indexed_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BottomNavBar extends StatelessWidget {
  final void Function(int)? onTap;
  final int index;
  const BottomNavBar({super.key, this.onTap, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return IndexedNavigationBar(
      items: [
        BottomNavItemData(label: 'Inicio', icon: MingCute.home_4_fill),
        BottomNavItemData(label: 'Enviar', icon: Iconsax.send_2_outline),
        BottomNavItemData(
          label: 'Depositar',
          icon: Iconsax.card_receive_outline,
        ),
        BottomNavItemData(label: 'Pagar', icon: MingCute.card_pay_line),
      ],
      selectedIndex: index,
      onTap: onTap,
    );
  }
}
