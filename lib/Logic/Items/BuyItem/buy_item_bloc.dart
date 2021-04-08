import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:js/js_util.dart';

import 'package:web3front/Helpers/CryptoAESHelper.dart';
import 'package:web3front/Logic/Items/SelectItem/cubit/select_item_cubit.dart';
import 'package:web3front/Logic/Market/bloc/market_items_bloc.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Services/market_contract_repository.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';
import 'package:web3front/main.dart';

part 'buy_item_event.dart';
part 'buy_item_state.dart';

class BuyItemBloc extends Bloc<BuyItemEvent, BuyItemState> {
  final web3 = Web3Provider(ethereum);
  final MarketContractRepository marketContractRepository;
  final SelectItemCubit selectItemCubit;
  final MarketItemsBloc marketItemsBloc;
  final CryptoAESHelper _crypto = CryptoAESHelper();
  BuyItemBloc({
    required this.marketContractRepository,
    required this.selectItemCubit,
    required this.marketItemsBloc,
  }) : super(BuyItemInitial());

  @override
  Stream<BuyItemState> mapEventToState(
    BuyItemEvent event,
  ) async* {
    if (event is BuyItemStart) {
      final int totalProgress = 4;

      /// First Loading
      yield BuyItemLoading(
        progress: 1,
        step: "Preparing Purchase Action",
        totalProgress: totalProgress,
      );

      try {
        final tokenHash = await marketContractRepository.getTokenHash(
            event.item.contractAddress, event.item.tokenId);

        if (tokenHash.msgHash != null && tokenHash.signature != null) {
          final msgHash = _crypto.decryptAESCryptoJS(tokenHash.msgHash!);
          final signature = _crypto.decryptAESCryptoJS(tokenHash.signature!);

          /// Current Market Contract Details
          final marketContractDetail =
              await marketContractRepository.getMarketContractDetails();

          /// Create a new User Contract instance
          final contract = Contract(
              marketContractDetail.address, marketContractDetail.abi, web3);

          /// Assign metamask signer to the contract (so we can perform a transaction)
          late final currentContract = contract.connect(web3.getSigner());

          /// Perform Buy Loading
          yield BuyItemLoading(
            progress: 2,
            step: "Perform Buy Action",
            totalProgress: totalProgress,
          );

          /// Check if market contract is already been approved.
          final buyToken = await promiseToFuture(callMethod(
            currentContract,
            'buyToken',
            [
              ethereum.selectedAddress!,
              event.item.tokenOwner,
              event.item.tokenId,
              event.item.price!.toString(),
              event.item.contractAddress,
              msgHash,
              signature,

              /// Overrides value parameter
              TxParams(value: event.item.price.toString())
            ],
          ));

          final result = jsonDecode(stringify(buyToken));
          final trxHash = result['hash'];

          /// Waiting the transaction to be mined
          yield BuyItemLoading(
              progress: 3,
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
          final isConfirmed = confirmationResult['status'];

          if (trxHash != null && isConfirmed >= 1) {
            yield BuyItemLoading(
                progress: 4,
                totalProgress: totalProgress,
                step: "Finalizing Buy Action");

            final finalize =
                await marketContractRepository.updateTokenOwnerAndRemoveListing(
                    tokenId: event.item.tokenId.toString(),
                    contractAddress: event.item.contractAddress,
                    tokenOwner: ethereum.selectedAddress!);

            if (finalize['message'] == "Token Updated Successfully") {
              /// Create a copy of item with price set to null, and on sale is false
              ItemsModel item = (selectItemCubit.state as SelectItemSelected)
                  .selectedItem
                  .copyWith(
                      isOnSale: 0,
                      price: null,
                      tokenOwner: ethereum.selectedAddress!);

              /// Emit the new item
              selectItemCubit.selectItem(selectedItem: item);

              /// Refresh the market
              marketItemsBloc.add(MarketItemsFetchStart());

              yield BuyItemSuccess(tokenId: event.item.tokenId.toString());
            } else {
              yield BuyItemFailed(error: "Error Updating Token Data");
            }
          }
        }
      } catch (e) {
        if (e.toString() == '[object Object]') {
          yield BuyItemFailed(error: jsonDecode(stringify(e))['message']);
        } else {
          print(jsonDecode(stringify(e)));
          yield BuyItemFailed(error: e.toString());
        }
      }
    }
  }
}
