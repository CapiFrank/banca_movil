import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/elevated_flex_container.dart';
import 'package:banca_movil/views/components/selectable_tab_item.dart';
import 'package:banca_movil/views/exchange_partials/currency_type.dart';
import 'package:flutter/material.dart';

class CurrencySelector extends StatelessWidget {
  final CurrencyType selectedCurrency;
  final VoidCallback onCurrencyChanged;
  final Color? color;

  const CurrencySelector({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedFlexContainer.sliverHorizontal(
      color: color ?? Palette(context).primary,
      children: [
        _buildCurrencyTab(
          context: context,
          text: "Dolar",
          isSelected: selectedCurrency == CurrencyType.dollar,
        ),
        _buildDivider(context),
        _buildCurrencyTab(
          context: context,
          text: "Euro",
          isSelected: selectedCurrency == CurrencyType.euro,
        ),
      ],
    );
  }

  Widget _buildCurrencyTab({
    required BuildContext context,
    required String text,
    required bool isSelected,
  }) {
    return SelectableTabItem(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      isSelected: isSelected,
      onPressed: onCurrencyChanged,
      primaryColor: Palette(context).surface,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Palette(context).surface),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Palette(context).surface.withValues(alpha: 0.8),
    );
  }
}
