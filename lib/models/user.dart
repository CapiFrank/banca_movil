import 'package:banca_movil/models/authorized_account.dart';
import 'package:banca_movil/utils/model.dart';
import 'package:banca_movil/utils/utilities.dart';

class User extends Model<User> {
  @override
  String get table => "users";

  @override
  List<String>? get embedRelations => ['authorized_accounts', 'accounts', 'favorite_accounts'];

  String name;
  String email;
  String citizenNumber;
  String phone;
  String password;
  String status;
  List<AuthorizedAccount> authorizedAccounts;

  User({
    super.id,
    this.name = "",
    this.email = "",
    this.citizenNumber = "",
    this.password = "",
    this.phone = "",
    this.status = "",
    this.authorizedAccounts = const [],
  });

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "citizen_number": citizenNumber,
    "password": password,
    "phone": phone,
    "status": status,
  };

  @override
  User fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    citizenNumber: json["citizen_number"],
    password: json["password"],
    phone: json["phone"],
    status: json["status"],
    authorizedAccounts: parseJsonList(
      AuthorizedAccount(),
      json['authorized_accounts'],
    ),
  );
}
