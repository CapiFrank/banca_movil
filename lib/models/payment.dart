import 'package:banca_movil/types/transaction_state_type.dart';
import 'package:banca_movil/types/transaction_type.dart';
import 'package:banca_movil/utils/model.dart';

class Payment extends Model<Payment> {
  String description;
  double amount;
  double comision;
  String currency;
  TransactionStateType status;
  TransactionType type;

  Payment({
    super.id,
    super.createdAt,
    super.updatedAt,
    this.amount = 0,
    this.description = "",
    this.currency = "",
    this.comision = 0,
    this.status = TransactionStateType.blocked,
    this.type = TransactionType.income,
  });

  @override
  List<String>? get embedRelations => throw UnimplementedError();

  @override
  Payment fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  String get table => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
