import 'package:banca_movil/models/user.dart';
import 'package:banca_movil/types/payment_method_type.dart';
import 'package:banca_movil/utils/controller.dart';
import 'package:banca_movil/models/favorite_account.dart';

class FavoriteAccountController extends Controller {
  final List<FavoriteAccount> _favoriteAccounts = [];

  List<FavoriteAccount> get favoriteAccounts =>
      List.unmodifiable(_favoriteAccounts);

  Future<void> index({required User user, required PaymentMethod type}) async {
    _favoriteAccounts.clear();
    final allAccounts = await FavoriteAccount().where(
      (f) => f.userId == user.id && f.type == type,
    );
    _favoriteAccounts.addAll(allAccounts);
  }

  Future<void> store({required FavoriteAccount favoriteAccount}) async {
    final savedFavoriteAccount = await favoriteAccount.create();
    _favoriteAccounts.insert(0, savedFavoriteAccount);
  }

  Future<void> update({required String id}) async {}

  Future<void> destroy({required FavoriteAccount favoriteAccount}) async {
    if (favoriteAccount.id == null) throw 'No existe el registro';
    favoriteAccount.delete();
    _favoriteAccounts.removeWhere((e) => e.id == favoriteAccount.id);
  }
}
