part of 'favorite_account_bloc.dart';

sealed class FavoriteAccountEvent extends Equatable {
  const FavoriteAccountEvent();

  @override
  List<Object> get props => [];
}

class FavoriteAccountCreated extends FavoriteAccountEvent {
  final FavoriteAccount favoriteAccount;
  const FavoriteAccountCreated({
    required this.favoriteAccount
  });
}
class FavoriteAccountDeleted extends FavoriteAccountEvent {
  final FavoriteAccount favoriteAccount;
  const FavoriteAccountDeleted({
    required this.favoriteAccount
  });
}

class FavoriteAccountsRequested extends FavoriteAccountEvent {
  final User user;
  final PaymentMethod type;
  const FavoriteAccountsRequested({required this.user, required this.type});

  @override
  List<Object> get props => [user];
}
