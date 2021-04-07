part of 'ethereum_price_cubit.dart';

abstract class EthereumPriceState extends Equatable {
  const EthereumPriceState();

  @override
  List<Object> get props => [];
}

class EthereumPriceCurrent extends EthereumPriceState {
  final String price;

  EthereumPriceCurrent(this.price);

  @override
  List<Object> get props => [price];
}

class EthereumPriceInitial extends EthereumPriceState {}
