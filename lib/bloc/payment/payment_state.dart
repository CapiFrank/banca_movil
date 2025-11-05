part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final bool saveAsFavorite;

  const PaymentState({this.saveAsFavorite = false});

  PaymentState copyWith({bool? saveAsFavorite}) {
    return PaymentState(saveAsFavorite: saveAsFavorite ?? this.saveAsFavorite);
  }

  @override
  List<Object?> get props => [saveAsFavorite];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentError extends PaymentState {
  final String message;
  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
