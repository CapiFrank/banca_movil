import 'package:banca_movil/utils/model.dart';

class AuthorizedAccount extends Model<AuthorizedAccount> {
  @override
  String get table => "authorized_accounts";

  String userId;
  String accountId;


  AuthorizedAccount({
    super.id,
    this.userId = '',
    this.accountId = '',
  });

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "accountId": accountId,
  };

  @override
  AuthorizedAccount fromJson(Map<String, dynamic> json) => AuthorizedAccount(
    id: json["id"],
    userId: json["userId"],
    accountId: json["accountId"],
  );

  @override
  List<String>? get embedRelations => [];
}
