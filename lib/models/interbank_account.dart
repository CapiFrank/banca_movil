import 'package:banca_movil/utils/model.dart';

class InterbankAccount extends Model<InterbankAccount> {
  String name;
  String ibanNumber;

  InterbankAccount({
    super.id,
    this.name = "",
    this.ibanNumber = "",
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iban_number': ibanNumber,
    };
  }

  @override
  InterbankAccount fromJson(Map<String, dynamic> json) {
    return InterbankAccount(
      id: json['id'],
      name: json['name'],
      ibanNumber: json['iban_number'],
    );
  }

  @override
  String get table => "interbank_accounts";

  @override
  List<String>? get embedRelations => [];
}