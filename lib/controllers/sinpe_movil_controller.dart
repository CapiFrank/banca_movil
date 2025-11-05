import 'package:banca_movil/utils/controller.dart';
import 'package:banca_movil/models/sinpe_movil.dart';

class SinpeMovilController extends Controller {
  Future<SinpeMovil> find(String phone) async {
    final sinpeMovil = await SinpeMovil().firstWhere((s) => s.phone == phone);
    if (sinpeMovil == null) throw 'Número no registrado';
    return sinpeMovil;
  }
}
