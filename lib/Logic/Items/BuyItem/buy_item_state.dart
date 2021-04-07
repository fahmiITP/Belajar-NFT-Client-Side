part of 'buy_item_bloc.dart';

abstract class BuyItemState extends Equatable {
  const BuyItemState();

  @override
  List<Object> get props => [];
}

class BuyItemInitial extends BuyItemState {}

class BuyItemSuccess extends BuyItemState {
  final String tokenId;
  final String? message;

  BuyItemSuccess({
    required this.tokenId,
    this.message,
  });

  @override
  List<Object> get props => [tokenId, message ?? ""];
}

class BuyItemFailed extends BuyItemState {
  final String error;

  BuyItemFailed({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class BuyItemLoading extends BuyItemState {
  final int progress;
  final int totalProgress;
  final String step;

  BuyItemLoading({
    required this.progress,
    required this.totalProgress,
    required this.step,
  });

  @override
  List<Object> get props => [progress, totalProgress, step];
}
