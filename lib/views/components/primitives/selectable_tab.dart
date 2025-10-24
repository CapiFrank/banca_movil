import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/primitives/selectable_tab_item.dart';
import 'package:flutter/material.dart';

class SelectableTab extends StatelessWidget {
  final List<SelectableTabItem> children;
  const SelectableTab({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette(context).primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [...children]),
    );
  }
}
