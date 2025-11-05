part of 'sinpe_movil_bloc.dart';

sealed class SinpeMovilEvent extends Equatable {
  const SinpeMovilEvent();

  @override
  List<Object?> get props => [];
}

class SearchSinpeMovilRequested extends SinpeMovilEvent {
  final String phone;
  const SearchSinpeMovilRequested(this.phone);

  @override
  List<Object?> get props => [phone];
}