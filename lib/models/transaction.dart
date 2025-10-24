import 'package:banca_movil/utils/model.dart';

enum TransactionStatus { applied, blocked }

enum TransactionType { income, expense }

class Transaction extends Model<Transaction> {
  final String description;
  final TransactionStatus status;
  final TransactionType type;
  final double amount;
  final String currency;

  Transaction({
    super.id,
    super.createdAt,
    super.updatedAt,
    this.description = '',
    this.status = TransactionStatus.blocked,
    this.amount = 0.0,
    this.currency = '',
    this.type = TransactionType.income,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'status': status.name, // almacena "applied" o "blocked"
      'type': type.name, // almacena "income" o "expense"
      'amount': amount,
      'currency': currency,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  Transaction fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.applied,
      ),
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
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
