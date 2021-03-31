import 'dart:convert';

class SellTokenMessageModel {
  final String sellerAddress;
  final String originalContractAddress;
  final double price;
  final String tradeMarketAddress;
  final String tokenId;
  SellTokenMessageModel({
    required this.sellerAddress,
    required this.originalContractAddress,
    required this.price,
    required this.tradeMarketAddress,
    required this.tokenId,
  });

  SellTokenMessageModel copyWith({
    String? sellerAddress,
    String? originalContractAddress,
    double? price,
    String? tradeMarketAddress,
    String? tokenId,
  }) {
    return SellTokenMessageModel(
      sellerAddress: sellerAddress ?? this.sellerAddress,
      originalContractAddress:
          originalContractAddress ?? this.originalContractAddress,
      price: price ?? this.price,
      tradeMarketAddress: tradeMarketAddress ?? this.tradeMarketAddress,
      tokenId: tokenId ?? this.tokenId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerAddress': sellerAddress,
      'originalContractAddress': originalContractAddress,
      'price': price,
      'tradeMarketAddress': tradeMarketAddress,
      'tokenId': tokenId,
    };
  }

  factory SellTokenMessageModel.fromMap(Map<String, dynamic> map) {
    return SellTokenMessageModel(
      sellerAddress: map['sellerAddress'],
      originalContractAddress: map['originalContractAddress'],
      price: map['price'],
      tradeMarketAddress: map['tradeMarketAddress'],
      tokenId: map['tokenId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SellTokenMessageModel.fromJson(String source) =>
      SellTokenMessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SellTokenMessageModel(sellerAddress: $sellerAddress, originalContractAddress: $originalContractAddress, price: $price, tradeMarketAddress: $tradeMarketAddress, tokenId: $tokenId)';
  }
}
