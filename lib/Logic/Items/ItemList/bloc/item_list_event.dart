part of 'item_list_bloc.dart';

abstract class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object> get props => [];
}

class ItemListFetchStart extends ItemListEvent {
  final String contractAddress;
  final String ownerAddress;

  ItemListFetchStart({
    required this.contractAddress,
    required this.ownerAddress,
  });

  @override
  List<Object> get props => [contractAddress, ownerAddress];
}
