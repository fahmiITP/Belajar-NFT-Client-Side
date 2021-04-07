part of 'buy_item_bloc.dart';

abstract class BuyItemEvent extends Equatable {
  const BuyItemEvent();

  @override
  List<Object> get props => [];
}

class BuyItemStart extends BuyItemEvent {
  final ItemsModel item;

  BuyItemStart({required this.item});

  @override
  List<Object> get props => [item];
}
