import 'package:banca_movil/utils/controller.dart';
import 'package:banca_movil/models/interbank_account.dart';

class InterbankAccountController extends Controller {
  Future<InterbankAccount> find(String ibanNumber) async {
    final interbankAccount = await InterbankAccount().firstWhere(
      (s) => s.ibanNumber == ibanNumber,
    );
    if (interbankAccount == null) throw 'Número no registrado';
    return interbankAccount;
  }
}
