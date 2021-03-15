part of 'mint_item_bloc.dart';

abstract class MintItemEvent extends Equatable {
  const MintItemEvent();

  @override
  List<Object> get props => [];
}

class MintItemStart extends MintItemEvent {
  final String imageBytes;
  final String itemName;
  final String itemDescription;

  MintItemStart({
    required this.imageBytes,
    required this.itemName,
    required this.itemDescription,
  });

  @override
  List<Object> get props => [imageBytes, itemName, itemDescription];
}
