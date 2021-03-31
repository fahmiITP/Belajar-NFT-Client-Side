import 'dart:convert';

class ItemPerContract {
  final String ownerAddress;
  final String name;
  final String image;
  final int tokenId;
  final int? isOnSale;
  final double? price;
  ItemPerContract({
    required this.ownerAddress,
    required this.name,
    required this.image,
    required this.tokenId,
    this.isOnSale,
    this.price,
  });

  ItemPerContract copyWith({
    String? ownerAddress,
    String? name,
    String? image,
    int? tokenId,
    int? isOnSale,
    double? price,
  }) {
    return ItemPerContract(
      ownerAddress: ownerAddress ?? this.ownerAddress,
      name: name ?? this.name,
      image: image ?? this.image,
      tokenId: tokenId ?? this.tokenId,
      isOnSale: isOnSale ?? this.isOnSale,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerAddress': ownerAddress,
      'name': name,
      'image': image,
      'tokenId': tokenId,
      'isOnSale': isOnSale,
      'price': price,
    };
  }

  factory ItemPerContract.fromMap(Map<String, dynamic> map) {
    return ItemPerContract(
      ownerAddress: map['ownerAddress'],
      name: map['name'],
      image: map['image'],
      tokenId: map['tokenId'],
      isOnSale: map['isOnSale'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemPerContract.fromJson(String source) =>
      ItemPerContract.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ItemPerContract(ownerAddress: $ownerAddress, name: $name, image: $image, tokenId: $tokenId, isOnSale: $isOnSale, price: $price)';
  }
}
