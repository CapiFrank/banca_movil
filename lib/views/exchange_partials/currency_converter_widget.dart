import 'package:banca_movil/models/exchange_rate.dart';
import 'package:banca_movil/views/components/flip_card.dart';
import 'package:banca_movil/views/components/input_text.dart';
import 'package:banca_movil/views/exchange_partials/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyConverterWidget extends StatelessWidget {
  final CurrencyConverter converter;
  final ExchangeRate rates;
  final String foreignCurrencyCode;
  final bool isColonesToForeign;

  const CurrencyConverterWidget({
    super.key,
    required this.converter,
    required this.rates,
    required this.foreignCurrencyCode,
    required this.isColonesToForeign,
  });

  void _onPrimaryInputChanged(String value) {
    if (value.isEmpty) {
      converter.secondaryController.clear();
      return;
    }

    final result = converter.convertFromPrimaryToSecondary(
      value: value,
      rates: rates,
      isColonesToForeign: isColonesToForeign,
    );
    
    converter.secondaryController.text = result.toStringAsFixed(2);
  }

  void _onSecondaryInputChanged(String value) {
    if (value.isEmpty) {
      converter.primaryController.clear();
      return;
    }

    final result = converter.convertFromSecondaryToPrimary(
      value: value,
      rates: rates,
      isColonesToForeign: isColonesToForeign,
    );
    
    converter.primaryController.text = result.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      isFlipped: isColonesToForeign,
      onFlip: () {},
      firstChild: _buildCurrencyInputs(
        primaryLabel: foreignCurrencyCode,
        secondaryLabel: 'CRC',
      ),
      secondChild: _buildCurrencyInputs(
        primaryLabel: 'CRC',
        secondaryLabel: foreignCurrencyCode,
      ),
    );
  }

  Widget _buildCurrencyInputs({
    required String primaryLabel,
    required String secondaryLabel,
  }) {
    return Column(
      children: [
        _buildCurrencyInput(
          controller: converter.primaryController,
          labelText: primaryLabel,
          onChanged: _onPrimaryInputChanged,
        ),
        const SizedBox(height: 16),
        _buildCurrencyInput(
          controller: converter.secondaryController,
          labelText: secondaryLabel,
          onChanged: _onSecondaryInputChanged,
        ),
      ],
    );
  }

  Widget _buildCurrencyInput({
    required TextEditingController controller,
    required String labelText,
    required Function(String) onChanged,
  }) {
    return InputText(
      labelText: labelText,
      textEditingController: controller,
      onTap: () => _selectAllText(controller),
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      inputFormatters: _getNumericInputFormatters(),
    );
  }

  void _selectAllText(TextEditingController controller) {
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
  }

  List<TextInputFormatter> _getNumericInputFormatters() {
    return [
      FilteringTextInputFormatter.deny(RegExp(r'\s')),
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    ];
  }
}