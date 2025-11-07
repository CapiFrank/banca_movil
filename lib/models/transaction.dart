import 'package:banca_movil/types/transaction_state_type.dart';
import 'package:banca_movil/types/transaction_type.dart';
import 'package:banca_movil/utils/model.dart';
import 'package:banca_movil/utils/utilities.dart';

class Transaction extends Model<Transaction> {
  TransactionStateType status;
  TransactionType type;
  double amount;
  String currency;

  Transaction({
    super.id,
    super.createdAt,
    super.updatedAt,
    this.status = TransactionStateType.blocked,
    this.amount = 0,
    this.currency = '',
    this.type = TransactionType.income,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.name, // almacena "applied" o "blocked"
      'type': type.name, // almacena "income" o "expense"
      'amount': amount,
      'currency': currency,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }

  @override
  Transaction fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      status: enumFromString(json['status'], TransactionStateType.values),
      type: enumFromString(json['type'], TransactionType.values),
      amount: (double.tryParse(json['amount'].toString()) ?? 0.0),
      currency: json['currency'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  String get table => "transactions";

  @override
  List<String>? get embedRelations => [];
}
