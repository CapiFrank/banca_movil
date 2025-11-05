part of 'exchange_rate_bloc.dart';

sealed class ExchangeRateEvent extends Equatable {
  const ExchangeRateEvent();

  @override
  List<Object?> get props => [];
}

class ExchangeRateRequested extends ExchangeRateEvent {}