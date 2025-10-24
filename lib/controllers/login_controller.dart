import 'package:banca_movil/utils/controller.dart';

import 'package:banca_movil/models/user.dart';
import 'package:banca_movil/utils/utilities.dart';

class UserController extends Controller {
  late User? _user;
  User? get user => _user;
  bool get isLogged => _user != null;

  Future<void> store(String citizenNumber, String password) async {
    setLoading(true);
    try {
      _user = await User().firstWhere(
        (element) =>
            element.citizenNumber == citizenNumber &&
            element.password == password,
      );
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> destroy(String citizenNumber, String password) async {
    setLoading(true);
    try {
      _user = null;
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }
}
