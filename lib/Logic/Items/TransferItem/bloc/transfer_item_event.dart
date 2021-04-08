part of 'transfer_item_bloc.dart';

abstract class TransferItemEvent extends Equatable {
  const TransferItemEvent();

  @override
  List<Object> get props => [];
}

class TransferItemStart extends TransferItemEvent {
  final int tokenId;
  final String newOwner;
  final String contractAddress;
  final ItemsModel item;

  TransferItemStart({
    required this.tokenId,
    required this.newOwner,
    required this.contractAddress,
    required this.item,
  });

  @override
  List<Object> get props => [tokenId, newOwner];
}
