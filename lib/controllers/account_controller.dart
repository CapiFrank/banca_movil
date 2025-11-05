import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/models/authorized_account.dart';
import 'package:banca_movil/models/user.dart';
import 'package:banca_movil/utils/controller.dart';

class AccountController extends Controller {
  final List<Account> _accounts = [];
  List<Account> get accounts => List.unmodifiable(_accounts);

  Future<void> index(User user) async {
    _accounts.clear();
    final authorizedAccounts = user.authorizedAccounts;
    final authorizedAccountIds = authorizedAccounts
        .whereType<AuthorizedAccount>()
        .map((account) => account.accountId)
        .toList();
    final allAccounts = await Account().all();
    final ownedAccounts = allAccounts
        .where((account) => account.userId == user.id)
        .toList();
    final sharedAccounts = allAccounts
        .where((account) => authorizedAccountIds.contains(account.id))
        .toList();

    final visibleAccounts = {...ownedAccounts, ...sharedAccounts}.toList();
    _accounts.addAll(visibleAccounts);
  }

  Future<Account> find(String accountNumber, bool isBankAccount) async {
    final account = await Account().firstWhere(
      (e) => (isBankAccount ? e.accountNumber : e.ibanNumber) == accountNumber,
    );
    if (account == null) throw 'Cuenta inválida';
    return account;
  }
}
