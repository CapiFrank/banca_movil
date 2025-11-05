part of 'favorite_account_bloc.dart';

sealed class FavoriteAccountState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteAccountInitial extends FavoriteAccountState {}

class FavoriteAccountLoading extends FavoriteAccountState {}

class FavoriteAccountLoaded extends FavoriteAccountState {
  final List<FavoriteAccount> favoriteAccounts;
  FavoriteAccountLoaded(this.favoriteAccounts);

  @override
  List<Object?> get props => [favoriteAccounts];
}

class FavoriteAccountError extends FavoriteAccountState {
  final String message;
  FavoriteAccountError(this.message);

  @override
  List<Object?> get props => [message];
}
