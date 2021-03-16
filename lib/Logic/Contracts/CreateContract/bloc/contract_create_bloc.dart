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
      final totalProgress = 3;
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
          yield ContractCreateLoading(
              progress: 2,
              totalProgress: totalProgress,
              step: "Deploying Contract");

          /// Get current chain id
          final chainId = await promiseToFuture(
              ethereum.request(RequestParams(method: 'eth_chainId')));

          /// Make sure user wallet is connected and on rinkeby network
          if (ethereum.isConnected() && chainId == "0x4") {
            var web3 = Web3Provider(ethereum);

            /// Deploy contract
            final deploy = await promiseToFuture(
              web3.getSigner().sendTransaction(
                    TxParams(data: byteCode),
                  ),
            );

            final contractAddress = jsonDecode(stringify(deploy))['creates'];

            if (contractAddress != null) {
              /// Update loading indicator
              yield ContractCreateLoading(
                  progress: 3,
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
