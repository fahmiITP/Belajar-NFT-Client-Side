part of 'contract_create_bloc.dart';

abstract class ContractCreateEvent extends Equatable {
  const ContractCreateEvent();

  @override
  List<Object> get props => [];
}

class ContractCreateStart extends ContractCreateEvent {
  final String contractName;
  final String contractSymbol;

  ContractCreateStart({
    required this.contractName,
    required this.contractSymbol,
  });

  @override
  List<Object> get props => [contractName, contractSymbol];
}
