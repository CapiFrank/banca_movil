part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class AccountsRequested extends AccountEvent {
  final User user;
  const AccountsRequested({required this.user});

  @override
  List<Object?> get props => [user];
}

class SearchAccountRequested extends AccountEvent {
  final String accountNumber;
  final bool isBankAccount;
  const SearchAccountRequested({required this.accountNumber, required this.isBankAccount});

  @override
  List<Object?> get props => [accountNumber, isBankAccount];
}
