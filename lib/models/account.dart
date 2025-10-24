import 'package:banca_movil/models/user.dart';
import 'package:banca_movil/utils/model.dart';

enum AccountType { checking, savings }

class Account extends Model<Account> {
  @override
  String get table => "accounts";

  final AccountType type;
  final String accountNumber;
  final String ibanNumber;
  final String userId;
  final double balance;
  final String currency;
  final User? user;

  Account({
    super.id,
    this.type = AccountType.savings,
    this.accountNumber = '',
    this.ibanNumber = '',
    this.userId = '',
    this.balance = 0.0,
    this.currency = '',
    this.user,
  });

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type.name,
    "account_number": accountNumber,
    "iban_number": ibanNumber,
    "userId": userId,
    "balance": balance,
    "currency": currency,
  };

  @override
  Account fromJson(Map<String, dynamic> json) => Account(
    id: json["id"],
    type: AccountType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => AccountType.savings,
    ),
    accountNumber: json["account_number"],
    ibanNumber: json["iban_number"],
    userId: json["userId"],
    balance: (double.tryParse(json['balance'].toString()) ?? 0.0),
    currency: json["currency"],
    user: User().fromJson(json["user"]),
  );

  @override
  List<String>? get embedRelations => ['user'];
}
