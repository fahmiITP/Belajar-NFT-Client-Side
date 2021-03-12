part of 'metamask_connect_bloc.dart';

abstract class MetamaskConnectState extends Equatable {
  const MetamaskConnectState();

  @override
  List<Object> get props => [];
}

class MetamaskConnectInitial extends MetamaskConnectState {}

class MetamaskConnectSuccess extends MetamaskConnectState {}

class MetamaskConnectFailed extends MetamaskConnectState {
  final String error;

  MetamaskConnectFailed({required this.error});

  @override
  List<Object> get props => [error];
}
