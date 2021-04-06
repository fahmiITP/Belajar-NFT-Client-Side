part of 'market_items_bloc.dart';

abstract class MarketItemsState extends Equatable {
  const MarketItemsState();

  @override
  List<Object> get props => [];
}

class MarketItemsInitial extends MarketItemsState {}

class MarketItemsLoading extends MarketItemsState {}

class MarketItemsSuccess extends MarketItemsState {
  final ItemListModel itemList;

  MarketItemsSuccess({required this.itemList});

  @override
  List<Object> get props => [itemList];
}

class MarketItemsFailed extends MarketItemsState {
  final String error;

  MarketItemsFailed({required this.error});

  @override
  List<Object> get props => [error];
}
