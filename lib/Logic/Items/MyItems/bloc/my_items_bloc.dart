import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:js/js_util.dart';

import 'package:web3front/Services/contract_repository.dart';
import 'package:web3front/Services/item_repository.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';

part 'my_items_event.dart';
part 'my_items_state.dart';

class MyItemsBloc extends Bloc<MyItemsEvent, MyItemsState> {
  final ItemRepository itemRepository = ItemRepository();
  final ContractRepository contractRepository = ContractRepository();
  MyItemsBloc() : super(MyItemsInitial());

  @override
  Stream<MyItemsState> mapEventToState(
    MyItemsEvent event,
  ) async* {
    if (event is MyItemsFetch) {
      yield MyItemsLoading();

      try {
        final myItems = await itemRepository.getAllUserTokens(
            ownerAddress: ethereum.selectedAddress!);

        /// Contract ABI
        final abi = await contractRepository.getContractAbi();

        /// Web3 Provider
        final web3 = Web3Provider(ethereum);

        List<MyItemsPerContractModel> myItemsPerContract = [];

        for (var item in myItems ?? []) {
          final contractAddress = item['contract_address'];
          if (myItemsPerContract
              .where((element) => element.contractAddress == contractAddress)
              .isEmpty) {
            /// Create a new Contract instance
            final contract = Contract(contractAddress, abi!, web3);

            /// Assign metamask signer to the contract (so we can perform a transaction)
            late final currentContract = contract.connect(web3.getSigner());

            /// Contract Name
            final contractName = await promiseToFuture(currentContract.name());

            myItemsPerContract.add(
              MyItemsPerContractModel(
                contractName: contractName.toString(),
                contractAddress: contractAddress,
                item: [
                  ItemPerContract(
                    ownerAddress: item['token_owner'],
                    name: item['name'],
                    image: item['image'],
                    tokenId: item['token_id'],
                  )
                ],
              ),
            );
          } else {
            myItemsPerContract
                .firstWhere(
                    (element) => element.contractAddress == contractAddress)
                .item
                .add(
                  ItemPerContract(
                    ownerAddress: item['token_owner'],
                    name: item['name'],
                    image: item['image'],
                    tokenId: item['token_id'],
                  ),
                );
          }
        }

        yield MyItemsSuccess(myItems: myItemsPerContract);
      } catch (e) {
        yield MyItemsFailed(error: e.toString());
      }
    }
  }
}

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

class ItemPerContract {
  final String ownerAddress;
  final String name;
  final String image;
  final int tokenId;
  ItemPerContract({
    required this.ownerAddress,
    required this.name,
    required this.image,
    required this.tokenId,
  });

  ItemPerContract copyWith({
    String? ownerAddress,
    String? name,
    String? image,
    int? tokenId,
  }) {
    return ItemPerContract(
      ownerAddress: ownerAddress ?? this.ownerAddress,
      name: name ?? this.name,
      image: image ?? this.image,
      tokenId: tokenId ?? this.tokenId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerAddress': ownerAddress,
      'name': name,
      'image': image,
      'tokenId': tokenId,
    };
  }

  factory ItemPerContract.fromMap(Map<String, dynamic> map) {
    return ItemPerContract(
      ownerAddress: map['ownerAddress'],
      name: map['name'],
      image: map['image'],
      tokenId: map['tokenId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemPerContract.fromJson(String source) =>
      ItemPerContract.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ItemPerContract(ownerAddress: $ownerAddress, name: $name, image: $image, tokenId: $tokenId)';
  }
}
