part of 'metamask_check_bloc.dart';

abstract class MetamaskCheckState extends Equatable {
  const MetamaskCheckState();

  @override
  List<Object> get props => [];
}

class MetamaskCheckInitial extends MetamaskCheckState {}

class MetamaskCheckNotInstalled extends MetamaskCheckState {}

class MetamaskCheckInstalled extends MetamaskCheckState {
  final Ethereum ethereum;
  final String chainId;

  MetamaskCheckInstalled(this.ethereum, this.chainId);

  @override
  List<Object> get props => [ethereum, chainId];
}
