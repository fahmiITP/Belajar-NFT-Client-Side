part of 'my_items_bloc.dart';

abstract class MyItemsEvent extends Equatable {
  const MyItemsEvent();

  @override
  List<Object> get props => [];
}

class MyItemsFetch extends MyItemsEvent {}
