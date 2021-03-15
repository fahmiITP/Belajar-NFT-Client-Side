part of 'contract_list_bloc.dart';

abstract class ContractListState extends Equatable {
  const ContractListState();

  @override
  List<Object> get props => [];
}

class ContractListInitial extends ContractListState {}

class ContractListFetchSuccess extends ContractListState {
  final List<dynamic> contractList;
  final List<String> contractReadableAbi;

  ContractListFetchSuccess({
    required this.contractList,
    required this.contractReadableAbi,
  });

  @override
  List<Object> get props => [contractList, contractReadableAbi];
}

class ContractListFetchFailed extends ContractListState {
  final String error;

  ContractListFetchFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class ContractListFetchLoading extends ContractListState {}
