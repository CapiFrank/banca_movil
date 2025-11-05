import 'package:banca_movil/utils/controller.dart';

import 'package:banca_movil/models/user.dart';

class AuthController extends Controller {
  late User? _user;
  User? get user => _user;
  bool get isLogged => _user != null;

  Future<void> store(String citizenNumber, String password) async {
    _user = await User().firstWhere(
      (element) =>
          element.citizenNumber == citizenNumber &&
          element.password == password,
    );
  }

  Future<void> destroy() async {
    _user = null;
  }
}
