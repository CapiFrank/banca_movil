part of 'account_bloc.dart';

sealed class AccountState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountSearchSuccess extends AccountState {
  final Account account;
  AccountSearchSuccess(this.account);

  @override
  List<Object?> get props => [account];
}

class AccountLoaded extends AccountState {
  final List<Account> accounts;
  AccountLoaded(this.accounts);

  @override
  List<Object?> get props => [accounts];
}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);

  @override
  List<Object?> get props => [message];
}
