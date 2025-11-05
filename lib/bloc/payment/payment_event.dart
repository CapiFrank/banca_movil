part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class ConfirmPaymentRequested extends PaymentEvent {
  final double amount;
  final FavoriteAccount favoriteAccount;
  final Account account;
  final String description;
  final PaymentMethod? paymentMethod;

  const ConfirmPaymentRequested({
    required this.amount,
    required this.favoriteAccount,
    required this.account,
    required this.description,
    this.paymentMethod
  });

  @override
  List<Object?> get props => [
    amount,
    favoriteAccount,
    account,
    description,
    paymentMethod
  ];
}

class SetPaymentMethodRequested extends PaymentEvent {
  final PaymentMethod paymentMethod;
  const SetPaymentMethodRequested(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class SetSaveFavoriteRequested extends PaymentEvent {
  final bool saveAsFavorite;
  const SetSaveFavoriteRequested(this.saveAsFavorite);

  @override
  List<Object?> get props => [saveAsFavorite];
}
