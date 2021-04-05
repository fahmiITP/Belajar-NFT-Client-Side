import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:js/js_util.dart';
import 'package:web3front/Helpers/EtherHelpers.dart';

import 'package:web3front/Logic/Contracts/ContractList/bloc/contract_list_bloc.dart';
import 'package:web3front/Logic/Contracts/ContractSelect/cubit/contract_select_cubit.dart';
import 'package:web3front/Services/item_repository.dart';
import 'package:web3front/Services/market_contract_repository.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';
import 'package:web3front/main.dart';

part 'sale_item_event.dart';
part 'sale_item_state.dart';

class SaleItemBloc extends Bloc<SaleItemEvent, SaleItemState> {
  final ItemRepository itemRepository = ItemRepository();
  final MarketContractRepository marketContractRepository;
  var web3 = Web3Provider(ethereum);
  final ContractListBloc contractListBloc;
  final ContractSelectCubit contractSelectCubit;
  SaleItemBloc({
    required this.contractListBloc,
    required this.contractSelectCubit,
    required this.marketContractRepository,
  }) : super(SaleItemInitial());

  @override
  Stream<SaleItemState> mapEventToState(
    SaleItemEvent event,
  ) async* {
    if (event is SaleItemStart) {
      /// Current User Contract Address
      final address =
          (contractSelectCubit.state as ContractSelectSelected).contractAddress;

      /// User Contract Human Readable ABI
      final abi = (contractListBloc.state as ContractListFetchSuccess)
          .contractReadableAbi;

      /// Create a new User Contract instance
      final contract = Contract(address, abi, web3);

      /// Assign metamask signer to the contract (so we can perform a transaction)
      late final currentContract = contract.connect(web3.getSigner());

      /// Current Market Contract Details
      final marketContractDetail =
          await marketContractRepository.getMarketContractDetails();

      /// Check if market contract is already been approved.
      final bool isApprovedRequest = await promiseToFuture(callMethod(
        currentContract,
        'isApprovedForAll',
        [ethereum.selectedAddress!, marketContractDetail.address],
      ));

      /// Determine total progress of required logics
      final totalProgress = isApprovedRequest ? 3 : 5;

      /// Gve the first loading
      yield SaleItemLoading(
          progress: 1,
          totalProgress: totalProgress,
          step: "Preparing the token sale");

      try {
        if (isApprovedRequest) {
          /// Encode the message
          final msg = EtherHelpers.signTokenSell(
              sellerAddress: ethereum.selectedAddress!,
              originalContractAddress: address,
              tradeMarketAddress: marketContractDetail.address,
              price: event.price.toString(),
              tokenId: event.tokenId.toString());

          /// Requesting for signature
          yield SaleItemLoading(
              progress: 2,
              totalProgress: totalProgress,
              step: "Requesting Signature (Please Sign the Message)");

          /// Request for Signature
          final signMsg = await promiseToFuture(
              web3.getSigner().signMessage(msg.arrayifyHash));

          final signature = stringify(signMsg);

          /// Requesting for signature
          yield SaleItemLoading(
              progress: 3,
              totalProgress: totalProgress,
              step: "Putting Token on Sale");

          try {
            await marketContractRepository.putTokenOnSale(
              isOnSale: "true",
              price: event.price,
              msgHash: msg.msgHash,
              signature: signature,
              tokenId: event.tokenId.toString(),
              contractAddress: address,
              tokenOwner: ethereum.selectedAddress!,
            );
            yield SaleItemSuccess(tokenId: event.tokenId.toString());
          } catch (e) {
            yield SaleItemFailed(error: e.toString());
          }
        } else {
          /// Requesting for market approval
          yield SaleItemLoading(
              progress: 2,
              totalProgress: totalProgress,
              step: "Requesting Market Contract to Operate All of Your Tokens");

          /// Set Token Approval
          final tokenApproval = await promiseToFuture(
            callMethod(
              currentContract,
              'setApprovalForAll',
              [marketContractDetail.address, true],
            ),
          );

          final result = jsonDecode(stringify(tokenApproval));
          final trxHash = result['hash'];

          /// Waiting the transaction to be mined
          yield SaleItemLoading(
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
            /// Encode the message
            final msg = EtherHelpers.signTokenSell(
                sellerAddress: ethereum.selectedAddress!,
                originalContractAddress: address,
                tradeMarketAddress: marketContractDetail.address,
                price: event.price.toString(),
                tokenId: event.tokenId.toString());

            /// Requesting for signature
            yield SaleItemLoading(
                progress: 4,
                totalProgress: totalProgress,
                step: "Requesting Signature (Please Sign the Message)");

            /// Request for Signature
            final signMsg = await promiseToFuture(
                web3.getSigner().signMessage(msg.arrayifyHash));

            final signature = stringify(signMsg);

            /// Requesting for signature
            yield SaleItemLoading(
                progress: 5,
                totalProgress: totalProgress,
                step: "Putting Token on Sale");

            try {
              await marketContractRepository.putTokenOnSale(
                isOnSale: "true",
                price: event.price,
                msgHash: msg.msgHash,
                signature: signature,
                tokenId: event.tokenId.toString(),
                contractAddress: address,
                tokenOwner: ethereum.selectedAddress!,
              );
              yield SaleItemSuccess(tokenId: event.tokenId.toString());
            } catch (e) {
              yield SaleItemFailed(error: e.toString());
            }
          } else {
            yield SaleItemFailed(error: "Error Selling Token");
          }
        }
      } catch (e) {
        if (e.toString() == "[object Object]") {
          yield SaleItemFailed(error: jsonDecode(stringify(e))['message']);
        } else {
          yield SaleItemFailed(error: e.toString());
        }
      }
    } else if (event is SaleItemCancelStart) {
      final totalProgress = 2;
      yield SaleItemLoading(
          progress: 1,
          step: "Requesting Signature",
          totalProgress: totalProgress);

      /// Hash the message
      final msgHash = Utils.keccak256(
        DefaultABICoder.encode(
          ['address', 'address', 'uint256'],
          [
            ethereum.selectedAddress!,
            event.contractAddress,
            event.tokenId,
          ],
        ),
      );

      /// Add Prefix
      final arrayify = Utils.arrayify(msgHash);

      try {
        /// Request for Signature
        await promiseToFuture(web3.getSigner().signMessage(arrayify));

        /// Requesting for signature
        yield SaleItemLoading(
            progress: 2,
            totalProgress: totalProgress,
            step: "Cancelling your token listing, please wait");

        /// Update sale state on DB
        await marketContractRepository.cancelTokenListing(
            tokenId: event.tokenId.toString(),
            contractAddress: event.contractAddress,
            tokenOwner: ethereum.selectedAddress!);

        yield SaleItemSuccess(
            tokenId: event.tokenId.toString(),
            message: "Your token has been taken out from market");
      } catch (e) {
        yield SaleItemFailed(error: e.toString());
      }
    }
  }
}
