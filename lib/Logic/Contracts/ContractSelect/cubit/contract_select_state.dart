part of 'contract_select_cubit.dart';

abstract class ContractSelectState extends Equatable {
  const ContractSelectState();

  @override
  List<Object> get props => [];
}

class ContractSelectInitial extends ContractSelectState {}

class ContractSelectSelected extends ContractSelectState {
  final String contractAddress;

  ContractSelectSelected({
    required this.contractAddress,
  });

  @override
  List<Object> get props => [contractAddress];
}
