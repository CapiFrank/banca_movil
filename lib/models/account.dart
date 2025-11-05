import 'package:banca_movil/models/user.dart';
import 'package:banca_movil/types/account_type.dart';
import 'package:banca_movil/utils/model.dart';
import 'package:banca_movil/utils/utilities.dart';



class Account extends Model<Account> {
  @override
  String get table => "accounts";

  AccountType type;
  String accountNumber;
  String ibanNumber;
  String userId;
  double balance;
  String currency;
  User? user;

  Account({
    super.id,
    this.type = AccountType.savings,
    this.accountNumber = '',
    this.ibanNumber = '',
    this.userId = '',
    this.balance = 0,
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
    type: enumFromString(json['type'], AccountType.values),
    accountNumber: json["account_number"],
    ibanNumber: json["iban_number"],
    userId: json["userId"],
    balance: (double.tryParse(json['balance'].toString()) ?? 0.0),
    currency: json["currency"],
    user: safeParse(json['user'], User()),
  );

  @override
  List<String>? get embedRelations => ['user'];
}
