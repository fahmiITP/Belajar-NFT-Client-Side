import 'dart:convert';

class MarketDetailModel {
  final String address;
  final List<String> abi;
  MarketDetailModel({
    required this.address,
    required this.abi,
  });

  MarketDetailModel copyWith({
    String? address,
    List<String>? abi,
  }) {
    return MarketDetailModel(
      address: address ?? this.address,
      abi: abi ?? this.abi,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'marketAddress': address,
      'abi': abi,
    };
  }

  factory MarketDetailModel.fromMap(Map<String, dynamic> map) {
    return MarketDetailModel(
      address: map['marketAddress'],
      abi: List<String>.from(map['abi']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MarketDetailModel.fromJson(String source) =>
      MarketDetailModel.fromMap(json.decode(source));

  @override
  String toString() => 'MarketDetailModel(marketAddress: $address, abi: $abi)';
}
