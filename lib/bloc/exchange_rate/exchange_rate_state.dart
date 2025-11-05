part of 'exchange_rate_bloc.dart';

sealed class ExchangeRateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExchangeRateInitial extends ExchangeRateState {}

class ExchangeRateLoading extends ExchangeRateState {}

class ExchangeRateLoaded extends ExchangeRateState {
  final List<ExchangeRate> exchangeRates;
  ExchangeRateLoaded(this.exchangeRates);

  @override
  List<Object?> get props => [exchangeRates];
}

class ExchangeRateError extends ExchangeRateState {
  final String message;
  ExchangeRateError(this.message);

  @override
  List<Object?> get props => [message];
}
