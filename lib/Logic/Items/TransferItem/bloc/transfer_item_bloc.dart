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

part 'transfer_item_event.dart';
part 'transfer_item_state.dart';

class TransferItemBloc extends Bloc<TransferItemEvent, TransferItemState> {
  final ItemRepository itemRepository = ItemRepository();
  var web3 = Web3Provider(ethereum);
  final ContractListBloc contractListBloc;
  final ContractSelectCubit contractSelectCubit;
  TransferItemBloc(
    this.contractListBloc,
    this.contractSelectCubit,
  ) : super(TransferItemInitial());

  @override
  Stream<TransferItemState> mapEventToState(
    TransferItemEvent event,
  ) async* {
    if (event is TransferItemStart) {
      final totalProgress = 2;
      yield TransferItemLoading(
          progress: 1, totalProgress: totalProgress, step: "Transfering Token");

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

        /// Transfer Token
        final transferToken = await promiseToFuture(
          callMethod(
            currentContract,
            'safeTransferFrom',
            [ethereum.selectedAddress, event.newOwner, event.tokenId],
          ),
        );

        final result = jsonDecode(stringify(transferToken));

        if (result['hash'] != null) {
          yield TransferItemLoading(
              progress: 2,
              totalProgress: totalProgress,
              step: "Updating Metadata");

          /// Save token meta data to DB
          await itemRepository.transferToken(
            newOwner: event.newOwner,
            contractAddress: address,
            tokenId: event.tokenId.toString(),
          );

          yield TransferItemSuccess(tokenId: event.tokenId.toString());
        } else {
          yield TransferItemFailed(error: "Error Transfering Token");
        }
      } catch (e) {
        if (e.toString() == "[object Object]") {
          yield TransferItemFailed(error: jsonDecode(stringify(e))['message']);
        } else {
          yield TransferItemFailed(error: e.toString());
        }
      }
    }
  }
}
