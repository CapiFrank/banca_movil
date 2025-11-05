part of 'interbank_account_bloc.dart';

sealed class InterbankAccountState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InterbankAccountInitial extends InterbankAccountState {}

class InterbankAccountLoading extends InterbankAccountState {}

class InterbankAccountSearchSuccess extends InterbankAccountState {
  final InterbankAccount interbankAccount;
  InterbankAccountSearchSuccess(this.interbankAccount);

  @override
  List<Object?> get props => [interbankAccount];
}

class InterbankAccountError extends InterbankAccountState {
  final String message;
  InterbankAccountError(this.message);

  @override
  List<Object?> get props => [message];
}
