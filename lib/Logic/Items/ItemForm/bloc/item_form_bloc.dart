import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'item_form_event.dart';
part 'item_form_state.dart';

class ItemFormBloc extends Bloc<ItemFormEvent, ItemFormState> {
  ItemFormBloc()
      : super(
          ItemFormInitial(
            imageBytes: "",
            itemDescription: "",
            itemName: "",
          ),
        );

  @override
  Stream<ItemFormState> mapEventToState(
    ItemFormEvent event,
  ) async* {
    if (event is ItemFormChanged) {
      yield ItemFormInitial(
        imageBytes: event.imageBytes,
        itemName: event.itemName,
        itemDescription: event.itemDescription,
      );
    }
  }
}
