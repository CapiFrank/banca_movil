import 'package:banca_movil/controllers/sinpe_movil_controller.dart';
import 'package:banca_movil/models/sinpe_movil.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sinpe_movil_event.dart';
part 'sinpe_movil_state.dart';

class SinpeMovilBloc extends Bloc<SinpeMovilEvent, SinpeMovilState> {
  final SinpeMovilController controller;

  SinpeMovilBloc(this.controller) : super(SinpeMovilInitial()) {
    on<SearchSinpeMovilRequested>(_onSearch);
  }
  Future<void> _onSearch(
    SearchSinpeMovilRequested event,
    Emitter<SinpeMovilState> emit,
  ) async {
    try {
      final sinpeMovil = await controller.find(event.phone);
      emit(SinpeMovilSearchSuccess(sinpeMovil));
    } catch (e) {
      emit(SinpeMovilError(e.toString()));
    }
  }
}
