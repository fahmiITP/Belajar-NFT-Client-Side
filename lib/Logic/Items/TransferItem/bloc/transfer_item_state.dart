part of 'transfer_item_bloc.dart';

abstract class TransferItemState extends Equatable {
  const TransferItemState();

  @override
  List<Object> get props => [];
}

class TransferItemInitial extends TransferItemState {}

class TransferItemSuccess extends TransferItemState {
  final String tokenId;

  TransferItemSuccess({
    required this.tokenId,
  });

  @override
  List<Object> get props => [tokenId];
}

class TransferItemFailed extends TransferItemState {
  final String error;

  TransferItemFailed({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class TransferItemLoading extends TransferItemState {
  final int progress;
  final int totalProgress;
  final String step;

  TransferItemLoading({
    required this.progress,
    required this.totalProgress,
    required this.step,
  });

  @override
  List<Object> get props => [progress, totalProgress, step];
}
