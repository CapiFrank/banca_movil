import 'package:banca_movil/types/payment_method_type.dart';
import 'package:banca_movil/utils/model.dart';
import 'package:banca_movil/utils/utilities.dart';

class Transfer extends Model<Transfer> {
  String sourceTransactionId;
  String destinationTransactionId;
  String sourceAccountId;
  String destinationAccountId;
  PaymentMethod paymentMethod;
  double amount;
  String description;
  double comision;

  Transfer({
    super.id,
    this.sourceTransactionId = '',
    this.destinationTransactionId = '',
    this.sourceAccountId = '',
    this.destinationAccountId = '',
    this.paymentMethod = PaymentMethod.sameBank,
    this.amount = 0,
    this.description = '',
    this.comision = 0,
  });

  @override
  Transfer fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'],
      sourceTransactionId: json['source_transactionId'],
      destinationTransactionId: json['destination_transactionId'],
      sourceAccountId: json['source_accountId'],
      destinationAccountId: json['destination_accountId'],
      paymentMethod: enumFromString(json['payment_method'], PaymentMethod.values),
      amount: (double.tryParse(json['amount'].toString()) ?? 0.0),
      description: json['description'],
      comision: (double.tryParse(json['comision'].toString()) ?? 0.0),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source_transactionId': sourceTransactionId,
      'destination_transactionId': destinationTransactionId,
      'source_accountId': sourceAccountId,
      'destination_accountId': destinationAccountId,
      'payment_method': paymentMethod.name,
      'amount': amount,
      'description': description,
      'comision': comision,
    };
  }

  @override
  String get table => 'transfers';

  @override
  List<String>? get embedRelations => [];
}
