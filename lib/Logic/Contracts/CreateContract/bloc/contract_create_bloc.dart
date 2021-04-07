import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:js/js_util.dart';
import 'package:web3front/Services/contract_repository.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';
import 'package:web3front/main.dart';

part 'contract_create_event.dart';
part 'contract_create_state.dart';

class ContractCreateBloc
    extends Bloc<ContractCreateEvent, ContractCreateState> {
  final ContractRepository contractRepository = ContractRepository();
  Timer? timer;
  ContractCreateBloc() : super(ContractCreateInitial());

  @override
  Stream<ContractCreateState> mapEventToState(
    ContractCreateEvent event,
  ) async* {
    if (event is ContractCreateStart) {
      final totalProgress = 4;

      /// Generate Bytecodes from Contract Name and Symbol
      yield ContractCreateLoading(
        progress: 1,
        totalProgress: totalProgress,
        step: "Generating Bytecodes",
      );
      try {
        final byteCode = await contractRepository.getEncodedAbi(
          contractName: event.contractName,
          contractSymbol: event.contractSymbol,
        );

        if (byteCode != null) {
          /// Update loading indicator
          /// Deploying Contract to Blockchain
          yield ContractCreateLoading(
              progress: 2,
              totalProgress: totalProgress,
              step: "Deploying Contract (Please Confirm the Transaction)");

          /// Get current chain id
          final chainId = await promiseToFuture(
              ethereum.request(RequestParams(method: 'eth_chainId')));

          /// Make sure user wallet is connected and on rinkeby network
          if (ethereum.isConnected() && chainId == "0x4") {
            var web3 = Web3Provider(ethereum);

            /// Get Gas Price
            final gasPrice = await promiseToFuture(web3.getGasPrice());

            /// Get Gas price on hex value
            final String parsedGasPrice =
                jsonDecode(stringify(gasPrice))['hex'];

            /// Get Estimated Gas Use
            final estimatedGas =
                await promiseToFuture(web3.getSigner().estimateGas(TxParams(
                      data: byteCode,
                    )));

            /// Get estimated gas use on hex value
            final String parsedEstimatedGas =
                jsonDecode(stringify(estimatedGas))['hex'];

            /// Deploy contract
            final deploy = await promiseToFuture(
              web3.getSigner().sendTransaction(
                    TxParams(
                        data: byteCode,
                        gasLimit: parsedEstimatedGas,
                        gasPrice: parsedGasPrice),
                  ),
            );

            /// Contract Deployment
            final deployResult = jsonDecode(stringify(deploy));

            /// Contract Address
            final contractAddress = deployResult['creates'];

            /// Transaction Hash
            final trxHash = deployResult['hash'];

            /// Waiting the transactio to be mined
            yield ContractCreateLoading(
                progress: 3,
                totalProgress: totalProgress,
                step: "Waiting the contract to be mined");

            /// Wait until the transaction has been mined
            final confirmation = await promiseToFuture(
              web3.waitForTransaction(trxHash),
            );

            /// Decode confirmation result
            final confirmationResult = jsonDecode(stringify(confirmation));

            /// Get the the confirmation result data
            /// If it's return 1, then it's confirmed, if null, then it's failed.
            final isConfirmed = confirmationResult['status'];

            if (contractAddress != null && isConfirmed >= 1) {
              /// Update loading indicator
              /// Save the contract to DB if it's already confirmed
              yield ContractCreateLoading(
                  progress: 4,
                  totalProgress: totalProgress,
                  step: "Saving Contract");

              final saveToDB = await contractRepository.saveContract(
                  contractAddress: contractAddress,
                  contractAbi: byteCode,
                  contractOwner: ethereum.selectedAddress!);

              if (saveToDB['message'] == 'Contract created successfully') {
                yield ContractCreateSuccess(contractAddress);
              } else {
                yield ContractCreateFailed(
                    "Error Saving Contract, please save manually (Feature to be added)");
              }
            } else {
              yield ContractCreateFailed(
                  "Error Deploying Contract, please make sure you have enough fund");
            }
          } else {
            yield ContractCreateFailed(
                "Error Deploying Contract, Please make sure that your network is on rinkeby, and your wallet is connected");
          }
        }
      } catch (e) {
        print(e);
        yield ContractCreateFailed("Error Creating Contract");
      }
    }
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
