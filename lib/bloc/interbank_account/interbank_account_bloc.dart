import 'package:banca_movil/controllers/interbank_account_controller.dart';
import 'package:banca_movil/models/interbank_account.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'interbank_account_event.dart';
part 'interbank_account_state.dart';

class InterbankAccountBloc
    extends Bloc<InterbankAccountEvent, InterbankAccountState> {
  final InterbankAccountController controller;

  InterbankAccountBloc(this.controller) : super(InterbankAccountInitial()) {
    on<SearchInterbankAccountRequested>(_onSearch);
  }
  Future<void> _onSearch(
    SearchInterbankAccountRequested event,
    Emitter<InterbankAccountState> emit,
  ) async {
    try {
      final interbankAccount = await controller.find(event.ibanNumber);
      emit(InterbankAccountSearchSuccess(interbankAccount));
    } catch (e) {
      emit(InterbankAccountError(e.toString()));
    }
  }
}
