import 'package:banca_movil/utils/model.dart';

class FavoriteAccount extends Model<FavoriteAccount> {
  String fullName;
  String accountNumber;

  FavoriteAccount({super.id, this.fullName = "", this.accountNumber = ""});

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'fullName': fullName, 'accountNumber': accountNumber};
  }

  @override
  FavoriteAccount fromJson(Map<String, dynamic> json) {
    return FavoriteAccount(
      id: json['id'],
      fullName: json['fullName'],
      accountNumber: json['accountNumber'],
    );
  }

  static FavoriteAccount fromDoc(id, data) {
    return FavoriteAccount(
      id: id,
      fullName: data['fullName'],
      accountNumber: data['accountNumber'],
    );
  }

  @override
  String get table => "favorite_accounts";

  @override
  List<String>? get embedRelations => [];
}
