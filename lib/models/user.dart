import 'package:banca_movil/utils/model.dart';

class User extends Model<User> {
  @override
  String get table => "users";

  @override
  List<String>? get embedRelations => [];

  String name;
  String email;
  String citizenNumber;
  String phone;
  String password;
  String status;

  User({
    super.id,
    this.name = "",
    this.email = "",
    this.citizenNumber = "",
    this.password = "",
    this.phone = "",
    this.status = "",
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
  );
}
