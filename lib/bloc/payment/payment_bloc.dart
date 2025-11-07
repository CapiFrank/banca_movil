import 'package:banca_movil/controllers/payment_controller.dart';
import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/models/favorite_account.dart';
import 'package:banca_movil/models/payment.dart';
import 'package:banca_movil/types/payment_method_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentController controller;
  PaymentMethod paymentMethod = PaymentMethod.sameBank;
  bool saveAsFavorite = false;

  PaymentBloc(this.controller) : super(PaymentInitial()) {
    on<SetPaymentMethodRequested>(_onPaymentMethodSelected);
    on<SetSaveFavoriteRequested>(_onSaveFavorite);
    on<ConfirmPaymentRequested>(_onConfirmPayment);
    on<PaymentRequested>(_onRequested);
  }
  void _onRequested(PaymentRequested event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      await controller.index(event.account);
      emit(
        PaymentLoaded(
          recentPayments: controller.recentPayments,
          olderPayments: controller.olderPayments,
        ),
      );
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  void _onSaveFavorite(
    SetSaveFavoriteRequested event,
    Emitter<PaymentState> emit,
  ) {
    saveAsFavorite = event.saveAsFavorite;
    emit(state.copyWith(saveAsFavorite: event.saveAsFavorite));
  }

  void _onPaymentMethodSelected(
    SetPaymentMethodRequested event,
    Emitter<PaymentState> emit,
  ) {
    paymentMethod = event.paymentMethod;
  }

  Future<void> _onConfirmPayment(
    ConfirmPaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());

    try {
      await controller.processPayment(
        amount: event.amount,
        account: event.account,
        favoriteAccount: event.favoriteAccount,
        transactionDescription: event.description,
        saveAsFavorite: saveAsFavorite,
        paymentMethod: event.paymentMethod ?? paymentMethod,
      );

      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentError(e.toString()));
    } finally {
      saveAsFavorite = false;
    }
  }
}
