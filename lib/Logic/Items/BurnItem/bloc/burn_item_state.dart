part of 'burn_item_bloc.dart';

abstract class BurnItemState extends Equatable {
  const BurnItemState();

  @override
  List<Object> get props => [];
}

class BurnItemInitial extends BurnItemState {}

class BurnItemSuccess extends BurnItemState {
  final String tokenId;
  final String contractAddress;

  BurnItemSuccess({
    required this.tokenId,
    required this.contractAddress,
  });

  @override
  List<Object> get props => [tokenId];
}

class BurnItemFailed extends BurnItemState {
  final String error;

  BurnItemFailed({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class BurnItemLoading extends BurnItemState {
  final int progress;
  final int totalProgress;
  final String step;

  BurnItemLoading({
    required this.progress,
    required this.totalProgress,
    required this.step,
  });

  @override
  List<Object> get props => [progress, totalProgress, step];
}
