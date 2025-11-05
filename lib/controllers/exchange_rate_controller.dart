import 'package:banca_movil/utils/controller.dart';
import 'package:banca_movil/models/exchange_rate.dart';

class ExchangeRateController extends Controller {
  final List<ExchangeRate> _exchangeRates = [];

  List<ExchangeRate> get exchangeRates => List.unmodifiable(_exchangeRates);

  Future<void> index() async {
      _exchangeRates.clear();
      _exchangeRates.addAll(await ExchangeRate().all());
  }

  Future<void> store({
    required String id,
  }) async {
      final exchangeRate = ExchangeRate(id: id);
      await exchangeRate.create();
      _exchangeRates.insert(0, exchangeRate);
  }

  Future<void> update({
    required String id,
  }) async {
      final exchangeRate = await ExchangeRate(id: id).find();
      if (exchangeRate == null) {
        throw Exception("⚠️ ExchangeRate with id $id not found");
      }
      await exchangeRate.update();

      final index = _exchangeRates.indexWhere((u) => u.id == id);
      if (index != -1) {
        _exchangeRates[index] = exchangeRate;
      }
  }

  Future<void> destroy({required String id}) async {
      final exchangeRate = ExchangeRate(id: id);
      await exchangeRate.delete();
      _exchangeRates.removeWhere((u) => u.id == id);
  }
}
