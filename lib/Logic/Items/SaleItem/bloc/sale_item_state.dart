part of 'sale_item_bloc.dart';

abstract class SaleItemState extends Equatable {
  const SaleItemState();

  @override
  List<Object> get props => [];
}

class SaleItemInitial extends SaleItemState {}

class SaleItemSuccess extends SaleItemState {
  final String tokenId;
  final String? message;

  SaleItemSuccess({
    required this.tokenId,
    this.message,
  });

  @override
  List<Object> get props => [tokenId, message ?? ""];
}

class SaleItemFailed extends SaleItemState {
  final String error;

  SaleItemFailed({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class SaleItemLoading extends SaleItemState {
  final int progress;
  final int totalProgress;
  final String step;

  SaleItemLoading({
    required this.progress,
    required this.totalProgress,
    required this.step,
  });

  @override
  List<Object> get props => [progress, totalProgress, step];
}
