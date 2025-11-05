part of 'interbank_account_bloc.dart';

sealed class InterbankAccountEvent extends Equatable {
  const InterbankAccountEvent();

  @override
  List<Object?> get props => [];
}

class SearchInterbankAccountRequested extends InterbankAccountEvent {
  final String ibanNumber;
  const SearchInterbankAccountRequested(this.ibanNumber);

  @override
  List<Object?> get props => [ibanNumber];
}
