part of 'sale_item_bloc.dart';

abstract class SaleItemEvent extends Equatable {
  const SaleItemEvent();

  @override
  List<Object> get props => [];
}

class SaleItemStart extends SaleItemEvent {
  final int tokenId;

  SaleItemStart({
    required this.tokenId,
  });

  @override
  List<Object> get props => [tokenId];
}
