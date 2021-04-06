import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web3front/Global/LocalStorageConstant.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';
import 'dart:html';

part 'select_item_state.dart';

class SelectItemCubit extends Cubit<SelectItemState> {
  SelectItemCubit() : super(SelectItemInitial());

  void selectItem({required ItemsModel selectedItem}) {
    window.localStorage[LocalStorageConstant.selectedItem] =
        selectedItem.toRawJson();
    emit(SelectItemSelected(selectedItem: selectedItem));
  }
}
