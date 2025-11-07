import 'package:banca_movil/models/payment.dart';
import 'package:banca_movil/models/transaction.dart';
import 'package:banca_movil/models/transfer.dart';
import 'package:banca_movil/models/favorite_account.dart';
import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/types/payment_method_type.dart';
import 'package:banca_movil/types/transaction_state_type.dart';
import 'package:banca_movil/types/transaction_type.dart';

class PaymentController {
  final List<Payment> _olderPayments = [];
  List<Payment> get olderPayments => List.unmodifiable(_olderPayments);
  final List<Payment> _recentPayments = [];
  List<Payment> get recentPayments => List.unmodifiable(_recentPayments);

  Future<void> index(Account account) async {
    _recentPayments.clear();
    _olderPayments.clear();

    // ✅ 1. Obtener las transferencias donde la cuenta es origen o destino
    final transfers = await Transfer().where(
      (t) =>
          t.sourceAccountId == account.id ||
          t.destinationAccountId == account.id,
    );

    if (transfers.isEmpty) return;

    // ✅ 2. Extraer todos los IDs de transacciones involucradas
    final transactionIds = transfers
        .map((t) => [t.sourceTransactionId, t.destinationTransactionId])
        .expand((e) => e)
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    // ✅ 3. Obtener todas las transacciones asociadas
    final transactions = await Transaction().where(
      (tx) => transactionIds.contains(tx.id),
    );

    // ✅ 4. Convertir en un mapa { id : transaction }
    final txMap = {for (var tx in transactions) tx.id!: tx};
    final now = DateTime.now();

    // ✅ 5. Convertir transferencias → Payments
    for (final tr in transfers) {
      // si tiene transacción destino -> ingreso
      if (tr.destinationAccountId == account.id &&
          txMap.containsKey(tr.destinationTransactionId)) {
        final tx = txMap[tr.destinationTransactionId]!;
        if (now.difference(tx.createdAt).inHours < 24) {
          _recentPayments.add(
            Payment(
              id: tx.id,
              description: tr.description,
              amount: tx.amount,
              comision: tr.comision,
              status: tx.status,
              currency: tx.currency,
              type: tx.type,
              createdAt: tx.createdAt,
              updatedAt: tx.updatedAt,
            ),
          );
        } else {
          _olderPayments.add(
            Payment(
              id: tx.id,
              description: tr.description,
              amount: tx.amount,
              comision: tr.comision,
              status: tx.status,
              currency: tx.currency,
              type: tx.type,
              createdAt: tx.createdAt,
              updatedAt: tx.updatedAt,
            ),
          );
        }
      }

      // si tiene transacción origen -> gasto
      if (tr.sourceAccountId == account.id &&
          txMap.containsKey(tr.sourceTransactionId)) {
        final tx = txMap[tr.sourceTransactionId]!;
        if (now.difference(tx.createdAt).inHours < 24) {
          _recentPayments.add(
            Payment(
              id: tx.id,
              description: tr.description,
              amount: tx.amount,
              comision: tr.comision,
              status: tx.status,
              currency: tx.currency,
              type: tx.type,
              createdAt: tx.createdAt,
              updatedAt: tx.updatedAt,
            ),
          );
        } else {
          _olderPayments.add(
            Payment(
              id: tx.id,
              description: tr.description,
              amount: tx.amount,
              comision: tr.comision,
              status: tx.status,
              currency: tx.currency,
              type: tx.type,
              createdAt: tx.createdAt,
              updatedAt: tx.updatedAt,
            ),
          );
        }
      }
    }
  }

  Future<void> processPayment({
    required double amount,
    required FavoriteAccount favoriteAccount,
    required Account account,
    required String transactionDescription,
    required bool saveAsFavorite,
    required PaymentMethod paymentMethod,
  }) async {
    try {
      final description = _composeDescription(
        paymentMethod,
        transactionDescription,
      );
      final isDeposit = paymentMethod == PaymentMethod.deposit;
      final now = DateTime.now();
      Account? sourceAccount;
      Account? destinationAccount;
      if (isDeposit) {
        destinationAccount = account;
      } else {
        sourceAccount = account;

        // Si no es SINPE, intentamos encontrar cuenta destino en banco
        if (paymentMethod != PaymentMethod.sinpe) {
          destinationAccount = await Account().firstWhere(
            (e) =>
                e.accountNumber == favoriteAccount.accountNumber ||
                e.ibanNumber == favoriteAccount.accountNumber,
          );
        }
      }

      final sourceTransaction = sourceAccount != null
          ? await Transaction(
              type: TransactionType.expense,
              status: TransactionStateType.applied,
              amount: amount,
              currency: sourceAccount.currency,
              createdAt: now,
              updatedAt: now,
            ).create()
          : null;

      final destinationTransaction = destinationAccount != null
          ? await Transaction(
              type: TransactionType.income,
              status: TransactionStateType.applied,
              amount: amount,
              currency: destinationAccount.currency,
              createdAt: now,
              updatedAt: now,
            ).create()
          : null;

      // 3️⃣ Crear transferencia (una sola vez)
      await Transfer(
        sourceTransactionId: sourceTransaction?.id ?? '',
        destinationTransactionId: destinationTransaction?.id ?? '',
        sourceAccountId: sourceAccount?.id ?? '',
        destinationAccountId: destinationAccount?.id ?? '',
        paymentMethod: paymentMethod,
        amount: amount,
        description: description,
        comision: 0,
      ).create();

      // 4️⃣ Actualizar saldos si aplica
      if (sourceAccount != null) {
        sourceAccount.balance -= amount;
        await sourceAccount.update();
      }

      if (destinationAccount != null) {
        destinationAccount.balance += amount;
        await destinationAccount.update();
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
