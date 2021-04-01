import 'dart:convert';

class ItemListModel {
  final List<ItemsModel> items;

  ItemListModel({
    required this.items,
  });

  factory ItemListModel.fromJson(List<dynamic> parsedJson) {
    List<ItemsModel> items = [];
    items = parsedJson.map((i) => ItemsModel.fromJson(i)).toList();

    return ItemListModel(items: items);
  }
}

class ItemsModel {
  final int id;
  final int tokenId;
  final String tokenOwner;
  final String contractAddress;
  final String name;
  final String description;
  final String image;
  final int? isOnSale;
  final double? price;

  ItemsModel({
    required this.id,
    required this.tokenId,
    required this.tokenOwner,
    required this.contractAddress,
    required this.name,
    required this.description,
    required this.image,
    this.isOnSale,
    this.price,
  });

  ItemsModel copyWith({
    int? id,
    int? tokenId,
    String? tokenOwner,
    String? contractAddress,
    String? name,
    String? description,
    String? image,
    int? isOnSale,
    double? price,
  }) =>
      ItemsModel(
        id: id ?? this.id,
        tokenId: tokenId ?? this.tokenId,
        tokenOwner: tokenOwner ?? this.tokenOwner,
        contractAddress: contractAddress ?? this.contractAddress,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        isOnSale: isOnSale ?? this.isOnSale,
        price: price ?? this.price,
      );

  factory ItemsModel.fromRawJson(String str) =>
      ItemsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemsModel.fromJson(Map<String, dynamic> json) => ItemsModel(
        id: json["id"] == null ? null : json["id"],
        tokenId: json["token_id"] == null ? null : json["token_id"],
        tokenOwner: json["token_owner"] == null ? null : json["token_owner"],
        contractAddress:
            json["contract_address"] == null ? null : json["contract_address"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        image: json["image"] == null ? null : json["image"],
        isOnSale: json["isOnSale"] == null ? null : json["isOnSale"],
        price: json["price"] == null ? null : json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "token_id": tokenId,
        "token_owner": tokenOwner,
        "contract_address": contractAddress,
        "name": name,
        "description": description,
        "image": image,
        "isOnSale": isOnSale == null ? null : isOnSale,
        "price": price == null ? null : price,
      };
}
