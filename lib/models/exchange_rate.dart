import 'package:banca_movil/utils/model.dart';

class ExchangeRate extends Model<ExchangeRate> {
  double buyRate;
  double sellRate;

  ExchangeRate({super.id, required this.buyRate, required this.sellRate});

  static ExchangeRate dollar = ExchangeRate(buyRate: 497.00, sellRate: 511.00);

  static ExchangeRate euro = ExchangeRate(buyRate: 580.02, sellRate: 602.22);

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'buy_rate': buyRate, 'sell_route': sellRate};
  }

  @override
  ExchangeRate fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      id: json['id'],
      buyRate: json['buy_rate'],
      sellRate: json['sell_rate '],
    );
  }

  static ExchangeRate fromDoc(id, data) {
    return ExchangeRate(
      id: id,
      buyRate: data['buy_rate'],
      sellRate: data['sell_rate'],
    );
  }

  @override
  String get table => "exchange_rates";

  @override
  List<String>? get embedRelations => [];
}
