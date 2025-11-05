import 'package:banca_movil/utils/model.dart';

class SinpeMovil extends Model<SinpeMovil> {
  String name;
  String phone;
  String accountNumber; 

  SinpeMovil({
    super.id,
    this.name = "",
    this.phone = "",
    this.accountNumber = "",
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'account_number': accountNumber,
    };
  }

  @override
  SinpeMovil fromJson(Map<String, dynamic> json) {
    return SinpeMovil(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      accountNumber: json['account_number'],
    );
  }

  @override
  String get table => "sinpe_movil";

  @override
  List<String>? get embedRelations => [];
}
