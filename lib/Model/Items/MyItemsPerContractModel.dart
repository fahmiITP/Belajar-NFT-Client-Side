import 'dart:convert';

import 'package:web3front/Model/Items/ItemPerContract.dart';

class MyItemsPerContractModel {
  final String contractAddress;
  final String contractName;
  final List<ItemPerContract> item;

  MyItemsPerContractModel({
    required this.contractAddress,
    required this.contractName,
    required this.item,
  });

  MyItemsPerContractModel copyWith({
    String? contractAddress,
    String? contractName,
    List<ItemPerContract>? item,
  }) {
    return MyItemsPerContractModel(
      contractAddress: contractAddress ?? this.contractAddress,
      contractName: contractName ?? this.contractName,
      item: item ?? this.item,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contractAddress': contractAddress,
      'contractName': contractName,
      'item': item.map((x) => x.toMap()).toList(),
    };
  }

  factory MyItemsPerContractModel.fromMap(Map<String, dynamic> map) {
    return MyItemsPerContractModel(
      contractAddress: map['contractAddress'],
      contractName: map['contractName'],
      item: List<ItemPerContract>.from(
          map['item']?.map((x) => ItemPerContract.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MyItemsPerContractModel.fromJson(String source) =>
      MyItemsPerContractModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'MyItemsPerContractModel(contractAddress: $contractAddress, contractName: $contractName, item: $item)';
}
