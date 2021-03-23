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

part 'sale_item_event.dart';
part 'sale_item_state.dart';

class SaleItemBloc extends Bloc<SaleItemEvent, SaleItemState> {
  final ItemRepository itemRepository = ItemRepository();
  var web3 = Web3Provider(ethereum);
  final ContractListBloc contractListBloc;
  final ContractSelectCubit contractSelectCubit;
  SaleItemBloc({
    required this.contractListBloc,
    required this.contractSelectCubit,
  }) : super(SaleItemInitial());

  @override
  Stream<SaleItemState> mapEventToState(
    SaleItemEvent event,
  ) async* {
    if (event is SaleItemStart) {
      final totalProgress = 2;
      yield SaleItemLoading(
          progress: 1,
          totalProgress: totalProgress,
          step: "Putting Token on Sale");

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

        /// Sale Token
        final saleToken = await promiseToFuture(
          callMethod(
            currentContract,
            'setApprovalForAll',
            [address, event.tokenId],
          ),
        );

        final result = jsonDecode(stringify(saleToken));

        /// Mint Token Transaction Hash
        final trxHash = result['hash'];

        /// Waiting the transaction to be mined
        yield SaleItemLoading(
            progress: 2,
            totalProgress: totalProgress,
            step: "Waiting the transaction to be mined");

        /// Wait until the transaction has been mined
        final confirmation = await promiseToFuture(
          web3.waitForTransaction(trxHash),
        );

        /// Decode confirmation result
        final confirmationResult = jsonDecode(stringify(confirmation));

        /// Get the the confirmation result data
        /// If it's return 1, then it's confirmed, if null, then it's failed.
        final isConfirmed = confirmationResult['confirmations'];

        if (result['hash'] != null) {
          yield SaleItemLoading(
              progress: 2,
              totalProgress: totalProgress,
              step: "Updating Metadata");

          yield SaleItemSuccess(tokenId: event.tokenId.toString());
        } else {
          yield SaleItemFailed(error: "Error Selling Token");
        }
      } catch (e) {
        if (e.toString() == "[object Object]") {
          yield SaleItemFailed(error: jsonDecode(stringify(e))['message']);
        } else {
          yield SaleItemFailed(error: e.toString());
        }
      }
    }
  }
}
