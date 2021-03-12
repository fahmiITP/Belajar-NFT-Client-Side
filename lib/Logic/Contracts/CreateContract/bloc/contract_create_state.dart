part of 'contract_create_bloc.dart';

abstract class ContractCreateState extends Equatable {
  const ContractCreateState();

  @override
  List<Object> get props => [];
}

class ContractCreateInitial extends ContractCreateState {}

class ContractCreateLoading extends ContractCreateState {
  final int progress;
  final int totalProgress;
  final String step;

  ContractCreateLoading({
    required this.progress,
    required this.totalProgress,
    required this.step,
  });

  @override
  List<Object> get props => [progress, totalProgress, step];
}

class ContractCreateSuccess extends ContractCreateState {
  final String contractAddress;

  ContractCreateSuccess(this.contractAddress);

  @override
  List<Object> get props => [contractAddress];
}

class ContractCreateFailed extends ContractCreateState {
  final String error;

  ContractCreateFailed(this.error);

  @override
  List<Object> get props => [error];
}
