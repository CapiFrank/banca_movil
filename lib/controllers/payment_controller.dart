import 'package:banca_movil/models/transaction.dart';
import 'package:banca_movil/models/transfer.dart';
import 'package:banca_movil/models/favorite_account.dart';
import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/types/payment_method_type.dart';
import 'package:banca_movil/types/transaction_type.dart';

class PaymentController {
  Future<void> processPayment({
    required double amount,
    required FavoriteAccount favoriteAccount,
    required Account account,
    required String transactionDescription,
    required bool saveAsFavorite,
    required PaymentMethod paymentMethod,
  }) async {
    try {
      final description = _composeDescription(paymentMethod, transactionDescription);
      final isDeposit = paymentMethod == PaymentMethod.deposit;
      final now = DateTime.now();

      final transaction = await Transaction(
        createdAt: now,
        updatedAt: now,
        currency: 'CRC',
        amount: amount,
        description: description,
        type: isDeposit ? TransactionType.income : TransactionType.expense,
      ).create();

      if (isDeposit) {
        await _processDeposit(
          transaction.id!,
          account,
          amount,
          description,
        );
      } else {
        await _processTransfer(
          transaction.id!,
          account,
          favoriteAccount,
          amount,
          description,
          paymentMethod,
        );
      }

      if (saveAsFavorite) {
        await _saveFavorite(favoriteAccount, paymentMethod);
      }
    } catch (e) {
      throw Exception("Error al procesar el pago: $e");
    }
  }

  String _composeDescription(PaymentMethod method, String base) {
    switch (method) {
      case PaymentMethod.sinpeMovil:
        return 'SINPE Móvil | $base';
      case PaymentMethod.deposit:
        return 'Depósito | $base';
      case PaymentMethod.sinpe:
        return 'Transferencia SINPE | $base';
      case PaymentMethod.sameBank:
        return 'Transferencia Interna | $base';
    }
  }

  Future<void> _processDeposit(
    String transactionId,
    Account account,
    double amount,
    String description,
  ) async {
    await Transfer(
      transactionId: transactionId,
      destinationAccountId: account.id!,
      amount: amount,
      description: description,
      comision: 0,
      type: PaymentMethod.deposit,
    ).create();

    account.balance += amount;
    await account.update();
  }

  Future<void> _processTransfer(
    String transactionId,
    Account sourceAccount,
    FavoriteAccount favorite,
    double amount,
    String description,
    PaymentMethod method,
  ) async {
    Account? destinationAccount;
    if (method != PaymentMethod.sinpeMovil) {
      destinationAccount = await Account().firstWhere(
        (e) =>
            e.accountNumber == favorite.accountNumber ||
            e.ibanNumber == favorite.accountNumber,
      );
    }

    await Transfer(
      transactionId: transactionId,
      sourceAccountId: sourceAccount.id!,
      destinationAccountId: destinationAccount?.id ?? '',
      amount: amount,
      description: description,
      type: method,
      comision: 0,
    ).create();

    if (destinationAccount != null &&
        method == PaymentMethod.sameBank) {
      destinationAccount.balance += amount;
      await destinationAccount.update();
    }

    sourceAccount.balance -= amount;
    await sourceAccount.update();
  }

  Future<void> _saveFavorite(
    FavoriteAccount original,
    PaymentMethod method,
  ) async {
    await FavoriteAccount(
      alias: original.alias,
      accountNumber: original.accountNumber,
      phone: original.phone,
      userId: original.userId,
      type: method,
    ).create();
  }
}
