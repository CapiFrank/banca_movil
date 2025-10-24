import 'package:banca_movil/models/exchange_rate.dart';
import 'package:banca_movil/views/components/primitives/selectable_tab.dart';
import 'package:banca_movil/views/components/primitives/selectable_tab_item.dart';
import 'package:flutter/material.dart';

class ExchangeRatesDisplay extends StatelessWidget {
  final ExchangeRate rates;
  final bool isColonesToForeign;
  final VoidCallback onDirectionChanged;

  const ExchangeRatesDisplay({
    super.key,
    required this.rates,
    required this.isColonesToForeign,
    required this.onDirectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableTab(
      children: [
        SelectableTabItem(
          title: "Compra",
          value: rates.buyRate.toStringAsFixed(2),
          isSelected: !isColonesToForeign,
          onPressed: onDirectionChanged,
          margin: EdgeInsets.all(4),
        ),
        SelectableTabItem(
          title: "Venta",
          value: rates.sellRate.toStringAsFixed(2),
          isSelected: isColonesToForeign,
          onPressed: onDirectionChanged,
          margin: EdgeInsets.all(4),
        ),
      ],
    );
  }
}
