part of 'market_items_bloc.dart';

abstract class MarketItemsEvent extends Equatable {
  const MarketItemsEvent();

  @override
  List<Object> get props => [];
}

/// Fetch market items
class MarketItemsFetchStart extends MarketItemsEvent {}

/// Sort market items
class MarketItemsSort extends MarketItemsEvent {
  final ItemListModel items;
  final MarketItemSortType sortType;

  MarketItemsSort({required this.items, required this.sortType});

  @override
  List<Object> get props => [items, sortType];
}

enum MarketItemSortType { PRICE_LOW, PRICE_HIGH }
