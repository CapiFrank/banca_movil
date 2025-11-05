part of 'sinpe_movil_bloc.dart';

sealed class SinpeMovilState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SinpeMovilInitial extends SinpeMovilState {}

class SinpeMovilLoading extends SinpeMovilState {}

class SinpeMovilSearchSuccess extends SinpeMovilState {
  final SinpeMovil sinpeMovil;
  SinpeMovilSearchSuccess(this.sinpeMovil);

  @override
  List<Object?> get props => [sinpeMovil];
}

class SinpeMovilError extends SinpeMovilState {
  final String message;
  SinpeMovilError(this.message);

  @override
  List<Object?> get props => [message];
}
