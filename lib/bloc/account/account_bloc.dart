import 'package:banca_movil/controllers/account_controller.dart';
import 'package:banca_movil/models/account.dart';
import 'package:banca_movil/models/user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountController controller;
  AccountBloc(this.controller) : super(AccountInitial()) {
    on<AccountsRequested>(_onRequested);
    on<SearchAccountRequested>(_onSearched);
  }
  Future<void> _onRequested(
    AccountsRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      await controller.index(event.user);
      emit(AccountLoaded(controller.accounts));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onSearched(
    SearchAccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    try {
      final account = await controller.find(
        event.accountNumber,
        event.isBankAccount,
      );
      emit(AccountSearchSuccess(account));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
