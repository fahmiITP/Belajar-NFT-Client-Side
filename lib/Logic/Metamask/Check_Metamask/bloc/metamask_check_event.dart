part of 'metamask_check_bloc.dart';

abstract class MetamaskCheckEvent extends Equatable {
  const MetamaskCheckEvent();

  @override
  List<Object> get props => [];
}

class MetamaskCheckStart extends MetamaskCheckEvent {}
