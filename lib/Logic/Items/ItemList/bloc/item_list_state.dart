part of 'item_list_bloc.dart';

abstract class ItemListState extends Equatable {
  const ItemListState();

  @override
  List<Object> get props => [];
}

class ItemListInitial extends ItemListState {}

class ItemListFetchSuccess extends ItemListState {
  final List<dynamic> tokenList;

  ItemListFetchSuccess({
    required this.tokenList,
  });

  @override
  List<Object> get props => [tokenList];
}

class ItemListFetchFailed extends ItemListState {
  final String error;

  ItemListFetchFailed({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class ItemListFetchLoading extends ItemListState {}
