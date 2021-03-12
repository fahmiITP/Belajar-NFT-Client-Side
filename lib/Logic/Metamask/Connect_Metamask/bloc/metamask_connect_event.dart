part of 'metamask_connect_bloc.dart';

abstract class MetamaskConnectEvent extends Equatable {
  const MetamaskConnectEvent();

  @override
  List<Object> get props => [];
}

class MetamaskConnectStart extends MetamaskConnectEvent {}
