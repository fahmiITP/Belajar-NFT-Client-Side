part of 'item_form_bloc.dart';

abstract class ItemFormEvent extends Equatable {
  const ItemFormEvent();

  @override
  List<Object> get props => [];
}

class ItemFormChanged extends ItemFormEvent {
  final String imageBytes;
  final String itemName;
  final String itemDescription;

  ItemFormChanged({
    required this.imageBytes,
    required this.itemName,
    required this.itemDescription,
  });

  @override
  List<Object> get props => [imageBytes, itemName, itemDescription];
}
