import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:js/js_util.dart';
import 'package:web3front/Global/Endpoints.dart';

import 'package:web3front/Logic/Contracts/ContractList/bloc/contract_list_bloc.dart';
import 'package:web3front/Logic/Contracts/ContractSelect/cubit/contract_select_cubit.dart';
import 'package:web3front/Services/item_repository.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';
import 'package:web3front/main.dart';

part 'mint_item_event.dart';
part 'mint_item_state.dart';

class MintItemBloc extends Bloc<MintItemEvent, MintItemState> {
  final ItemRepository itemRepository = ItemRepository();
  var web3 = Web3Provider(ethereum);
  final ContractListBloc contractListBloc;
  final ContractSelectCubit contractSelectCubit;
  MintItemBloc({
    required this.contractListBloc,
    required this.contractSelectCubit,
  }) : super(MintItemInitial());

  @override
  Stream<MintItemState> mapEventToState(
    MintItemEvent event,
  ) async* {
    if (event is MintItemStart) {
      final totalProgress = 4;
      yield MintItemLoading(
          progress: 1,
          totalProgress: totalProgress,
          step: "Minting Token (Please Confirm the Transaction)");

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

        /// Total Token
        final totalToken = await promiseToFuture(
            callMethod(currentContract, 'totalToken', []));

        /// New Token
        final rawTotalToken = jsonDecode(stringify(totalToken));
        final parsedTotalToken = int.parse(rawTotalToken['hex']);
        final newToken = parsedTotalToken + 1;

        /// Mint Token
        final mintToken =
            await promiseToFuture(callMethod(currentContract, 'mint', [
          ethereum.selectedAddress,
          newToken,
          "${Endpoints.apiBaseUrl}tokens/metadata/$address/$newToken"
        ]));

        /// Mint Token Result
        final result = jsonDecode(stringify(mintToken));

        /// Mint Token Transaction Hash
        final trxHash = result['hash'];

        /// Waiting the transaction to be mined
        yield MintItemLoading(
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

        if (result['hash'] != null && isConfirmed >= 1) {
          yield MintItemLoading(
              progress: 3,
              totalProgress: totalProgress,
              step: "Uploading Image");

          try {
            /// Upload Image to Firestore
            final uploadRes = await itemRepository.uploadImageToStorage(
                encodedImage: event.imageBytes,
                fileName: newToken.toString(),
                contractAddress: address);

            if (uploadRes != null) {
              yield MintItemLoading(
                  progress: 4,
                  totalProgress: totalProgress,
                  step: "Uploading Metadata");

              try {
                /// Save token meta data to DB
                await itemRepository.saveTokenMetadata(
                  contractAddress: address,
                  ownerAddress: ethereum.selectedAddress!,
                  imageBytes: uploadRes,
                  itemName: event.itemName,
                  itemDescription: event.itemDescription,
                  tokenId: newToken.toString(),
                );
                yield MintItemSuccess(tokenId: newToken.toString());
              } catch (e) {
                yield MintItemFailed(error: "Upload Metadata ${e.toString()}");
              }
            }
          } catch (e) {
            yield MintItemFailed(error: "Cannot Save Metadata");
          }
        } else {
          yield MintItemFailed(error: "Cannot Mint Token $confirmationResult");
        }
      } catch (e) {
        if (e.toString() == "[object Object]") {
          yield MintItemFailed(error: jsonDecode(stringify(e))['message']);
        } else {
          yield MintItemFailed(error: e.toString());
        }
      }
    }
  }
}
