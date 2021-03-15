part of 'transfer_item_bloc.dart';

abstract class TransferItemEvent extends Equatable {
  const TransferItemEvent();

  @override
  List<Object> get props => [];
}

class TransferItemStart extends TransferItemEvent {
  final int tokenId;
  final String newOwner;

  TransferItemStart({
    required this.tokenId,
    required this.newOwner,
  });

  @override
  List<Object> get props => [tokenId, newOwner];
}
