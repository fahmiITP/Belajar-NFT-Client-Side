part of 'burn_item_bloc.dart';

abstract class BurnItemEvent extends Equatable {
  const BurnItemEvent();

  @override
  List<Object> get props => [];
}

class BurnItemStart extends BurnItemEvent {
  final int tokenId;
  final String contractAddress;

  BurnItemStart({
    required this.tokenId,
    required this.contractAddress,
  });

  @override
  List<Object> get props => [tokenId];
}
