import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:js/js_util.dart';

import 'package:web3front/Logic/Contracts/ContractList/bloc/contract_list_bloc.dart';
import 'package:web3front/Logic/Contracts/ContractSelect/cubit/contract_select_cubit.dart';
import 'package:web3front/Services/item_repository.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';
import 'package:web3front/main.dart';

part 'burn_item_event.dart';
part 'burn_item_state.dart';

class BurnItemBloc extends Bloc<BurnItemEvent, BurnItemState> {
  final ItemRepository itemRepository = ItemRepository();
  var web3 = Web3Provider(ethereum);
  final ContractListBloc contractListBloc;
  final ContractSelectCubit contractSelectCubit;
  BurnItemBloc(
    this.contractListBloc,
    this.contractSelectCubit,
  ) : super(BurnItemInitial());

  @override
  Stream<BurnItemState> mapEventToState(
    BurnItemEvent event,
  ) async* {
    if (event is BurnItemStart) {
      final totalProgress = 2;
      yield BurnItemLoading(
          progress: 1, totalProgress: totalProgress, step: "Burning Token");

      try {
        /// Current Contract Address
        final address = (contractSelectCubit.state as ContractSelectSelected)
            .contractAddress;

        /// Human Readable ABI
        final abi = (contractListBloc.state as ContractListFetchSuccess)
            .contractReadableAbi;

        /// Create a new Contract instance
        final contract = Contract(address, abi, web3);

        /// Assign metamask signer to the contract (so we can perform a transaction)
        late final currentContract = contract.connect(web3.getSigner());

        /// burn Token
        final burnToken = await promiseToFuture(
          callMethod(
            currentContract,
            'burn',
            [event.tokenId],
          ),
        );

        final result = jsonDecode(stringify(burnToken));

        if (result['hash'] != null) {
          yield BurnItemLoading(
              progress: 2,
              totalProgress: totalProgress,
              step: "Updating Metadata");

          /// Save token meta data to DB
          await itemRepository.burnToken(
            contractAddress: address,
            tokenId: event.tokenId.toString(),
          );

          yield BurnItemSuccess(tokenId: event.tokenId.toString());
        } else {
          yield BurnItemFailed(error: "Error Burning Token");
        }
      } catch (e) {
        if (e.toString() == "[object Object]") {
          yield BurnItemFailed(error: jsonDecode(stringify(e))['message']);
        } else {
          yield BurnItemFailed(error: e.toString());
        }
      }
    }
  }
}
