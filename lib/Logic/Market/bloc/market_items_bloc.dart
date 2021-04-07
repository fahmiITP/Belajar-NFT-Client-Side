import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Services/market_contract_repository.dart';

part 'market_items_event.dart';
part 'market_items_state.dart';

class MarketItemsBloc extends Bloc<MarketItemsEvent, MarketItemsState> {
  final MarketContractRepository marketContractRepository;
  MarketItemsBloc({required this.marketContractRepository})
      : super(MarketItemsInitial());

  @override
  Stream<MarketItemsState> mapEventToState(
    MarketItemsEvent event,
  ) async* {
    if (event is MarketItemsFetchStart) {
      yield MarketItemsLoading();

      try {
        /// Fetch All Items on Sale
        final ItemListModel items =
            await marketContractRepository.getAllOnSaleToken();
        yield MarketItemsSuccess(itemList: items);
      } catch (e) {
        yield MarketItemsFailed(error: e.toString());
      }
    } else if (event is MarketItemsSort) {
      ItemListModel sortedItem = event.items.copyWith();
      if (event.sortType == MarketItemSortType.PRICE_LOW) {
        sortedItem.items.sort((lhs, rhs) => lhs.price!.compareTo(rhs.price!));
      } else {
        sortedItem.items.sort((lhs, rhs) => rhs.price!.compareTo(lhs.price!));
      }
      yield MarketItemsSuccess(itemList: sortedItem);
    }
  }
}
