part of 'select_item_cubit.dart';

abstract class SelectItemState extends Equatable {
  const SelectItemState();

  @override
  List<Object> get props => [];
}

class SelectItemInitial extends SelectItemState {}

class SelectItemSelected extends SelectItemState {
  final ItemsModel selectedItem;

  SelectItemSelected({
    required this.selectedItem,
  });

  @override
  List<Object> get props => [selectedItem];
}
