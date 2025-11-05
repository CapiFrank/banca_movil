import 'package:banca_movil/types/currency_type.dart';
import 'package:banca_movil/utils/model.dart';
import 'package:banca_movil/utils/utilities.dart';

class ExchangeRate extends Model<ExchangeRate> {
  double buyRate;
  double sellRate;
  CurrencyType currency;
  dynamic date;

  ExchangeRate({
    super.id,
    this.buyRate = 0,
    this.sellRate = 0,
    this.currency = CurrencyType.dollar,
    this.date = '',
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buy_rate': buyRate,
      'sell_route': sellRate,
      'currency': currency.name,
      'date': date,
    };
  }

  @override
  ExchangeRate fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      id: json['id'],
      buyRate: (double.tryParse(json['buy_rate'].toString()) ?? 0.0),
      sellRate: (double.tryParse(json['sell_rate'].toString()) ?? 0.0),
      currency: enumFromString(json['currency'], CurrencyType.values),
      date: DateTime.parse(json['date']),
    );
  }

  @override
  String get table => "exchange_rates";

  @override
  List<String>? get embedRelations => [];
}
