part of 'contract_form_bloc.dart';

abstract class ContractFormState extends Equatable {
  const ContractFormState();

  @override
  List<Object> get props => [];
}

class ContractFormInitial extends ContractFormState {
  final String contractName;
  final String contractSymbol;

  ContractFormInitial({
    required this.contractName,
    required this.contractSymbol,
  });

  @override
  List<Object> get props => [contractName, contractSymbol];
}
