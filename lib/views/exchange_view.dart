import 'package:banca_movil/models/exchange_rate.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/elevated_flex_container.dart';
import 'package:banca_movil/views/partials/exchange_partials/converter_header.dart';
import 'package:banca_movil/views/partials/exchange_partials/currency_converter.dart';
import 'package:banca_movil/views/partials/exchange_partials/currency_converter_widget.dart';
import 'package:banca_movil/views/partials/exchange_partials/currency_selector.dart';
import 'package:banca_movil/views/partials/exchange_partials/currency_type.dart';
import 'package:banca_movil/views/partials/exchange_partials/exchange_rates_display.dart';
import 'package:banca_movil/views/layouts/base_scaffold.dart';
import 'package:banca_movil/views/layouts/scroll_layout.dart';
import 'package:flutter/material.dart';

class ExchangeView extends StatefulWidget {
  const ExchangeView({super.key});

  @override
  State<ExchangeView> createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView>
    with SingleTickerProviderStateMixin {
  bool _isColonesToForeignCurrency = false;
  CurrencyType _selectedCurrency = CurrencyType.dollar;
  final _currencyConverter = CurrencyConverter();
  ExchangeRate get _currentRates => _selectedCurrency == CurrencyType.dollar
      ? ExchangeRate.dollar
      : ExchangeRate.euro;
  String get _foreignCurrencyCode =>
      _selectedCurrency == CurrencyType.dollar ? 'USD' : 'EUR';

  void _handleConversionDirectionChange() {
    setState(() {
      _isColonesToForeignCurrency = !_isColonesToForeignCurrency;
      _currencyConverter.swapValues(
        rates: _currentRates,
        isColonesToForeign: _isColonesToForeignCurrency,
      );
    });
  }

  void _handleCurrencyTypeChange() {
    setState(() {
      _selectedCurrency = _selectedCurrency == CurrencyType.dollar
          ? CurrencyType.euro
          : CurrencyType.dollar;
      _isColonesToForeignCurrency = false;
      _currencyConverter.clearInputs();
    });
  }

  @override
  void dispose() {
    _currencyConverter.dispose();
    super.dispose();
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Tipo de Cambio',
      style: TextStyle(
        color: Palette(context).surface,
        fontSize: 26,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildCurrencySelector(BuildContext context) {
    return CurrencySelector(
      selectedCurrency: _selectedCurrency,
      onCurrencyChanged: _handleCurrencyTypeChange,
    );
  }

  Widget _buildExchangeContent(BuildContext context) {
    return ElevatedFlexContainer.sliverVertical(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 0.0,
        bottom: 16.0,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        ExchangeRatesDisplay(
          rates: _currentRates,
          isColonesToForeign: _isColonesToForeignCurrency,
          onDirectionChanged: _handleConversionDirectionChange,
        ),
        SizedBox(height: 16),
        ConverterHeader(onSwapPressed: _handleConversionDirectionChange),
        SizedBox(height: 16),
        CurrencyConverterWidget(
          converter: _currencyConverter,
          rates: _currentRates,
          foreignCurrencyCode: _foreignCurrencyCode,
          isColonesToForeign: _isColonesToForeignCurrency,
        ),
        SizedBox(height: 16),
        Text(
          "Última actualización: 20/10/2023 14:30",
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Palette(context).background,
      body: ScrollLayout(
        automaticallyImplyLeading: true,
        toolbarHeight: 50,
        backgroundColor: Palette(context).primary,
        headerChild: _buildHeader(context),
        children: [
          _buildCurrencySelector(context),
          SliverToBoxAdapter(child: const SizedBox(height: 8.0)),
          _buildExchangeContent(context),
        ],
      ),
    );
  }
}
