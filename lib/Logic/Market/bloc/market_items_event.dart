part of 'market_items_bloc.dart';

abstract class MarketItemsEvent extends Equatable {
  const MarketItemsEvent();

  @override
  List<Object> get props => [];
}

class MarketItemsFetchStart extends MarketItemsEvent {}
