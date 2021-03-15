import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web3front/Services/contract_repository.dart';

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
