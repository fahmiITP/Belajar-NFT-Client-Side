part of 'sale_item_bloc.dart';

abstract class SaleItemEvent extends Equatable {
  const SaleItemEvent();

  @override
  List<Object> get props => [];
}

class SaleItemStart extends SaleItemEvent {
  final int tokenId;
  final double price;

  SaleItemStart({
    required this.tokenId,
    required this.price,
  });

  @override
  List<Object> get props => [tokenId, price];
}

class SaleItemCancelStart extends SaleItemEvent {
  final int tokenId;
  final String contractAddress;

  SaleItemCancelStart({
    required this.tokenId,
    required this.contractAddress,
  });

  @override
  List<Object> get props => [tokenId, contractAddress];
}
