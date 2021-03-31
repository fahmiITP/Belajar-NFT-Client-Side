import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:js/js_util.dart';
import 'package:web3front/Model/Items/ItemPerContract.dart';
import 'package:web3front/Model/Items/MyItemsPerContractModel.dart';

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
                    isOnSale: item['isOnSale'],
                    price: item['price'],
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
