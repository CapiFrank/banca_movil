import 'package:banca_movil/controllers/favorite_account_controller.dart';
import 'package:banca_movil/models/favorite_account.dart';
import 'package:banca_movil/models/user.dart';
import 'package:banca_movil/types/payment_method_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'favorite_account_event.dart';
part 'favorite_account_state.dart';

class FavoriteAccountBloc
    extends Bloc<FavoriteAccountEvent, FavoriteAccountState> {
  final FavoriteAccountController controller;

  FavoriteAccountBloc(this.controller) : super(FavoriteAccountInitial()) {
    on<FavoriteAccountsRequested>(_onRequested);
    on<FavoriteAccountCreated>(_onCreated);
    on<FavoriteAccountDeleted>(_onDeleted);
  }
  Future<void> _onRequested(
    FavoriteAccountsRequested event,
    Emitter<FavoriteAccountState> emit,
  ) async {
    try {
      await controller.index(user: event.user, type: event.type);
      emit(FavoriteAccountLoaded(controller.favoriteAccounts));
    } catch (e) {
      emit(FavoriteAccountError(e.toString()));
    }
  }

  Future<void> _onCreated(
    FavoriteAccountCreated event,
    Emitter<FavoriteAccountState> emit,
  ) async {
    try {
      await controller.store(
        favoriteAccount: event.favoriteAccount
      );
      emit(FavoriteAccountLoaded(controller.favoriteAccounts));
    } catch (e) {
      emit(FavoriteAccountError(e.toString()));
    }
  }

  Future<void> _onDeleted(
    FavoriteAccountDeleted event,
    Emitter<FavoriteAccountState> emit,
  ) async {
    try {
      await controller.destroy(
        favoriteAccount: event.favoriteAccount
      );
      emit(FavoriteAccountLoaded(controller.favoriteAccounts));
    } catch (e) {
      emit(FavoriteAccountError(e.toString()));
    }
  }
}
