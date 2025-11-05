import 'package:banca_movil/types/payment_method_type.dart';
import 'package:banca_movil/utils/model.dart';
import 'package:banca_movil/utils/utilities.dart';

class FavoriteAccount extends Model<FavoriteAccount> {
  String userId;
  String alias;
  String accountNumber;
  String phone;
  PaymentMethod type;

  FavoriteAccount({
    super.id,
    this.userId = "",
    this.alias = "",
    this.type = PaymentMethod.sameBank,
    this.accountNumber = "",
    this.phone = "",
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'alias': alias,
      'account_number': accountNumber,
      'phone': phone,
      'type': type.name,
    };
  }

  @override
  FavoriteAccount fromJson(Map<String, dynamic> json) {
    return FavoriteAccount(
      id: json['id'],
      userId: json['userId'],
      alias: json['alias'],
      accountNumber: json['account_number'],
      phone: json['phone'],
      type: enumFromString(json['type'], PaymentMethod.values),
    );
  }

  @override
  String get table => "favorite_accounts";

  @override
  List<String>? get embedRelations => [];
}
