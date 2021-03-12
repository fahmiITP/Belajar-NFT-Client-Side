part of 'contract_form_bloc.dart';

abstract class ContractFormEvent extends Equatable {
  const ContractFormEvent();

  @override
  List<Object> get props => [];
}

class ContractFormChanged extends ContractFormEvent {
  final String contractName;
  final String contractSymbol;

  ContractFormChanged(
      {required this.contractName, required this.contractSymbol});

  @override
  List<Object> get props => [contractName, contractSymbol];
}
