import 'package:banca_movil/utils/model.dart';

class Account extends Model<Account> {
  @override
  String get table => "accounts";

  final String type;
  final String number;
  final String owner;
  final String balance;

  Account({
    super.id,
    required this.type,
    required this.number,
    required this.owner,
    required this.balance,
  });

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "number": number,
    "owner": owner,
    "balance": balance,
  };

  @override
  Account fromJson(Map<String, dynamic> json) => Account(
    id: json["id"],
    type: json["type"],
    number: json["number"],
    owner: json["owner"],
    balance: json["balance"],
  );
}
