part of 'item_form_bloc.dart';

abstract class ItemFormState extends Equatable {
  const ItemFormState();

  @override
  List<Object> get props => [];
}

class ItemFormInitial extends ItemFormState {
  final String imageBytes;
  final String itemName;
  final String itemDescription;

  ItemFormInitial({
    required this.imageBytes,
    required this.itemName,
    required this.itemDescription,
  });

  @override
  List<Object> get props => [imageBytes, itemName, itemDescription];
}
