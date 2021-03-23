part of 'my_items_bloc.dart';

abstract class MyItemsState extends Equatable {
  const MyItemsState();

  @override
  List<Object> get props => [];
}

class MyItemsInitial extends MyItemsState {}

class MyItemsSuccess extends MyItemsState {
  final List<MyItemsPerContractModel> myItems;

  MyItemsSuccess({
    required this.myItems,
  });

  @override
  List<Object> get props => [myItems];
}

class MyItemsFailed extends MyItemsState {
  final String error;

  MyItemsFailed({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class MyItemsLoading extends MyItemsState {}
