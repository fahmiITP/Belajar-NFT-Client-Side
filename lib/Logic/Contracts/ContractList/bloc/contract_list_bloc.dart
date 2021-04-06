import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web3front/Global/LocalStorageConstant.dart';
import 'package:web3front/Services/contract_repository.dart';
import 'dart:html';

part 'contract_list_event.dart';
part 'contract_list_state.dart';

class ContractListBloc extends Bloc<ContractListEvent, ContractListState> {
  final ContractRepository contractRepository = ContractRepository();
  ContractListBloc() : super(ContractListInitial());

  @override
  Stream<ContractListState> mapEventToState(
    ContractListEvent event,
  ) async* {
    if (event is ContractListFetch) {
      yield ContractListFetchLoading();

      try {
        final contractList = await contractRepository.getContracts(
            userAddress: event.userAddress);

        final contractABI = await contractRepository.getContractAbi();

        if (contractList != null && contractABI != null) {
          /// Save ABI to local storage
          window.localStorage[LocalStorageConstant.userContractAbi] =
              jsonEncode(contractABI);

          /// Yield Success State
          yield ContractListFetchSuccess(
            contractList: contractList,
            contractReadableAbi: contractABI,
          );
        } else {
          ContractListFetchFailed(error: "Contract list returned null");
        }
      } catch (e) {
        yield ContractListFetchFailed(error: e.toString());
      }
    }
  }
}
