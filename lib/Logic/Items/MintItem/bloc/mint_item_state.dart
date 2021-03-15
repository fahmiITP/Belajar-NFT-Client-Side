part of 'mint_item_bloc.dart';

abstract class MintItemState extends Equatable {
  const MintItemState();

  @override
  List<Object> get props => [];
}

class MintItemInitial extends MintItemState {}

class MintItemSuccess extends MintItemState {
  final String tokenId;

  MintItemSuccess({
    required this.tokenId,
  });

  @override
  List<Object> get props => [tokenId];
}

class MintItemFailed extends MintItemState {
  final String error;

  MintItemFailed({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class MintItemLoading extends MintItemState {
  final int progress;
  final int totalProgress;
  final String step;

  MintItemLoading({
    required this.progress,
    required this.totalProgress,
    required this.step,
  });

  @override
  List<Object> get props => [progress, totalProgress, step];
}
