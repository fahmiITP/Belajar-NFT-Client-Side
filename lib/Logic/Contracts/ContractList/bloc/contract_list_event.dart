part of 'contract_list_bloc.dart';

abstract class ContractListEvent extends Equatable {
  const ContractListEvent();

  @override
  List<Object> get props => [];
}

class ContractListFetch extends ContractListEvent {
  final String userAddress;

  ContractListFetch({required this.userAddress});

  @override
  List<Object> get props => [userAddress];
}
