import 'package:banca_movil/bloc/exchange_rate/exchange_rate_bloc.dart';
import 'package:banca_movil/models/exchange_rate.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/utils/utilities.dart';
import 'package:banca_movil/types/currency_type.dart';
import 'package:banca_movil/views/components/primitives/loading_progress.dart';
import 'package:banca_movil/views/components/primitives/sweet_alert.dart';
import 'package:banca_movil/views/components/layouts/base_scaffold.dart';
import 'package:banca_movil/views/components/layouts/scroll_layout.dart';
import 'package:banca_movil/views/components/primitives/elevated_flex_container.dart';
import 'package:banca_movil/views/partials/exchange_partials/exchange_rates_display.dart';
import 'package:banca_movil/views/partials/exchange_partials/converter_header.dart';
import 'package:banca_movil/views/partials/exchange_partials/currency_converter.dart';
import 'package:banca_movil/views/partials/exchange_partials/currency_selector.dart';
import 'package:banca_movil/views/partials/exchange_partials/currency_converter_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangeView extends StatefulWidget {
  const ExchangeView({super.key});

  @override
  State<ExchangeView> createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView>
    with SingleTickerProviderStateMixin {
  bool _isColonesToForeign = false;
  CurrencyType _selectedCurrency = CurrencyType.dollar;
  final CurrencyConverter _converter = CurrencyConverter();
  late List<ExchangeRate> _rates = [];

  String get _foreignCode =>
      _selectedCurrency == CurrencyType.dollar ? 'USD' : 'EUR';

  ExchangeRate get _currentRate =>
      _rates.firstWhere((e) => e.currency == _selectedCurrency);

  @override
  void initState() {
    super.initState();
    // Solicitar datos cuando la vista esté construida
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExchangeRateBloc>().add(ExchangeRateRequested());
    });
  }

  @override
  void dispose() {
    _converter.dispose();
    super.dispose();
  }

  Widget _header(BuildContext context) => Text(
    'Tipo de Cambio',
    style: TextStyle(
      color: Palette(context).surface,
      fontSize: 26,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _currencySelector() => CurrencySelector(
    selectedCurrency: _selectedCurrency,
    onCurrencyChanged: () {
      setState(() {
        _selectedCurrency = _selectedCurrency == CurrencyType.dollar
            ? CurrencyType.euro
            : CurrencyType.dollar;

        _isColonesToForeign = false;
        _converter.clearInputs();
      });
    },
  );

  Widget _converterContent(BuildContext context) =>
      ElevatedFlexContainer.sliverVertical(
        borderRadius: BorderRadius.circular(16),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        children: [
          ExchangeRatesDisplay(
            rates: _currentRate,
            isColonesToForeign: _isColonesToForeign,
            onDirectionChanged: () {
              setState(() {
                _isColonesToForeign = !_isColonesToForeign;
                _converter.swapValues(
                  rates: _currentRate,
                  isColonesToForeign: _isColonesToForeign,
                );
              });
            },
          ),
          const SizedBox(height: 16),
          ConverterHeader(
            onSwapPressed: () {
              setState(() {
                _isColonesToForeign = !_isColonesToForeign;
                _converter.swapValues(
                  rates: _currentRate,
                  isColonesToForeign: _isColonesToForeign,
                );
              });
            },
          ),
          const SizedBox(height: 16),
          CurrencyConverterWidget(
            converter: _converter,
            rates: _currentRate,
            isColonesToForeign: _isColonesToForeign,
            foreignCurrencyCode: _foreignCode,
          ),
          const SizedBox(height: 16),
          Text(
            "Última actualización: ${formatDateTime(_currentRate.date)}",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExchangeRateBloc, ExchangeRateState>(
      listener: (context, state) {
        if (state is ExchangeRateError) {
          SweetAlert.show(
            context: context,
            type: SweetAlertType.error,
            message: state.message,
            autoClose: const Duration(seconds: 2),
          );
        }
      },
      builder: (context, state) => LoadingProgress(
        isLoaded: state is! ExchangeRateLoaded,
        builder: () {
          if (state is ExchangeRateLoaded) {
            _rates = state.exchangeRates;
            return BaseScaffold(
              backgroundColor: Palette(context).background,
              body: ScrollLayout(
                isEmpty: _rates.isEmpty,
                emptyMessage: 'No hay informacion',
                automaticallyImplyLeading: true,
                toolbarHeight: 50,
                backgroundColor: Palette(context).primary,
                headerChild: _header(context),
                children: [
                  _currencySelector(),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  _converterContent(context),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
