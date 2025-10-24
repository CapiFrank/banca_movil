import 'package:banca_movil/models/transaction.dart';
import 'package:banca_movil/utils/model.dart';

enum TransferType { sinpe, sinpeMovil, sameBank }

class Transfer extends Model<Transfer> {
  final String transactionId;
  final String sourceAccountId;
  final String destinationAccountId;
  final TransferType type;
  final double amount;
  final String description;
  final double comision;
  final Transaction? transaction;

  Transfer({
    super.id,
    this.transactionId = '',
    this.sourceAccountId = '',
    this.destinationAccountId = '',
    this.type = TransferType.sameBank,
    this.amount = 0.0,
    this.description = '',
    this.comision = 0.0,
    this.transaction,
  });

  @override
  Transfer fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'],
      transactionId: json['transactionId'],
      sourceAccountId: json['source_accountId'],
      destinationAccountId: json['destination_accountId'],
      type: TransferType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransferType.sameBank,
      ),
      amount: (double.tryParse(json['amount'].toString()) ?? 0.0),
      description: json['description'],
      comision: (double.tryParse(json['comision'].toString()) ?? 0.0),
      transaction: Transaction().fromJson(json['transaction']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'source_accountId': sourceAccountId,
      'destination_accountId': destinationAccountId,
      'type': type.name,
      'amount': amount,
      'description': description,
      'comision': comision,
    };
  }

  @override
  String get table => 'transfers';

  @override
  List<String>? get embedRelations => ['transaction'];
}
