part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para intentar iniciar sesión
class AuthLoginRequested extends AuthEvent {
  final String citizenNumber;
  final String password;

  const AuthLoginRequested({required this.citizenNumber, required this.password});

  @override
  List<Object?> get props => [citizenNumber, password];
}

/// Evento para cerrar sesión
class AuthLogoutRequested extends AuthEvent {}
