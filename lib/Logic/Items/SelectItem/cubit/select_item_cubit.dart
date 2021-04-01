import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';

part 'select_item_state.dart';

class SelectItemCubit extends Cubit<SelectItemState> {
  SelectItemCubit() : super(SelectItemInitial());

  void selectContract({required ItemsModel selectedItem}) =>
      emit(SelectItemSelected(selectedItem: selectedItem));
}
