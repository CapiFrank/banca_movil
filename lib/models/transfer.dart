import 'package:banca_movil/models/transaction.dart';
import 'package:banca_movil/types/payment_method_type.dart';
import 'package:banca_movil/utils/model.dart';
import 'package:banca_movil/utils/utilities.dart';

class Transfer extends Model<Transfer> {
  String transactionId;
  String sourceAccountId;
  String destinationAccountId;
  PaymentMethod type;
  double amount;
  String description;
  double comision;
  Transaction? transaction;

  Transfer({
    super.id,
    this.transactionId = '',
    this.sourceAccountId = '',
    this.destinationAccountId = '',
    this.type = PaymentMethod.sameBank,
    this.amount = 0,
    this.description = '',
    this.comision = 0,
    this.transaction,
  });

  @override
  Transfer fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'],
      transactionId: json['transactionId'],
      sourceAccountId: json['source_accountId'],
      destinationAccountId: json['destination_accountId'],
      type: enumFromString(json['type'], PaymentMethod.values),
      amount: (double.tryParse(json['amount'].toString()) ?? 0.0),
      description: json['description'],
      comision: (double.tryParse(json['comision'].toString()) ?? 0.0),
      transaction: safeParse(json['transaction'], Transaction()),
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
