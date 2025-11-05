import 'package:banca_movil/controllers/exchange_rate_controller.dart';
import 'package:banca_movil/models/exchange_rate.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'exchange_rate_event.dart';
part 'exchange_rate_state.dart';

class ExchangeRateBloc extends Bloc<ExchangeRateEvent, ExchangeRateState> {
  final ExchangeRateController controller;

  ExchangeRateBloc(this.controller) : super(ExchangeRateInitial()) {
    on<ExchangeRateRequested>(_onRequested);
  }
  Future<void> _onRequested(
    ExchangeRateRequested event,
    Emitter<ExchangeRateState> emit,
  ) async {
    try {
      await controller.index();
      emit(ExchangeRateLoaded(controller.exchangeRates));
    } catch (e) {
      emit(ExchangeRateError(e.toString()));
    }
  }
}
