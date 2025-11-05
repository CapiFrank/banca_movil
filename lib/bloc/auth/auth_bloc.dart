import 'package:banca_movil/controllers/auth_controller.dart';
import 'package:banca_movil/models/user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthController controller;
  User? get user => controller.user;

  AuthBloc(this.controller) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await controller.store(event.citizenNumber, event.password);
      if (controller.isLogged) {
        emit(AuthAuthenticated(controller.user!));
      } else {
        throw 'Cédula o contraseña incorrectos.';
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await controller.destroy();
    emit(AuthLoggedOut());
  }
}
