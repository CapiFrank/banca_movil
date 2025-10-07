import 'package:banca_movil/models/exchange_rate.dart';
import 'package:flutter/material.dart';

class CurrencyConverter {
  final TextEditingController _primaryController = TextEditingController();
  final TextEditingController _secondaryController = TextEditingController();

  TextEditingController get primaryController => _primaryController;
  TextEditingController get secondaryController => _secondaryController;

  void clearInputs() {
    _primaryController.clear();
    _secondaryController.clear();
  }

  void swapValues({
    required ExchangeRate rates,
    required bool isColonesToForeign,
  }) {
    if (!isColonesToForeign && _secondaryController.text.isNotEmpty) {
      _primaryController.text = _secondaryController.text;
      final result = convertFromPrimaryToSecondary(
        value: _secondaryController.text,
        rates: rates,
        isColonesToForeign: isColonesToForeign,
      );
      secondaryController.text = result.toStringAsFixed(2);
      
    } else if (isColonesToForeign && _primaryController.text.isNotEmpty) {
      _secondaryController.text = _primaryController.text;
      final result = convertFromSecondaryToPrimary(
        value: _primaryController.text,
        rates: rates,
        isColonesToForeign: isColonesToForeign,
      );
      primaryController.text = result.toStringAsFixed(2);
    }
  }

  double convertFromPrimaryToSecondary({
    required String value,
    required ExchangeRate rates,
    required bool isColonesToForeign,
  }) {
    final input = double.tryParse(value);
    if (input == null) return 0;

    return isColonesToForeign ? input / rates.sellRate : input * rates.buyRate;
  }

  double convertFromSecondaryToPrimary({
    required String value,
    required ExchangeRate rates,
    required bool isColonesToForeign,
  }) {
    final input = double.tryParse(value);
    if (input == null) return 0;

    return isColonesToForeign ? input * rates.sellRate : input / rates.buyRate;
  }

  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
  }
}
