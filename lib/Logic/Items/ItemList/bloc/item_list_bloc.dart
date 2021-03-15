import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web3front/Services/item_repository.dart';

part 'item_list_event.dart';
part 'item_list_state.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  final ItemRepository itemRepository = ItemRepository();
  ItemListBloc() : super(ItemListInitial());

  @override
  Stream<ItemListState> mapEventToState(
    ItemListEvent event,
  ) async* {
    if (event is ItemListFetchStart) {
      yield ItemListFetchLoading();

      try {
        final tokens = await itemRepository.getContractTokens(
            contractAddress: event.contractAddress,
            ownerAddress: event.ownerAddress);

        if (tokens != null) {
          yield ItemListFetchSuccess(tokenList: tokens);
        } else {
          yield ItemListFetchFailed(error: "No Token Available");
        }
      } catch (e) {
        yield ItemListFetchFailed(error: e.toString());
      }
    }
  }
}
