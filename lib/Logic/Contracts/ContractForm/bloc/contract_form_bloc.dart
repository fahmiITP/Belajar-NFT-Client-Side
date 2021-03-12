import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'contract_form_event.dart';
part 'contract_form_state.dart';

class ContractFormBloc extends Bloc<ContractFormEvent, ContractFormState> {
  ContractFormBloc()
      : super(ContractFormInitial(contractName: "", contractSymbol: ""));

  @override
  Stream<ContractFormState> mapEventToState(
    ContractFormEvent event,
  ) async* {
    if (event is ContractFormChanged) {
      yield ContractFormInitial(
          contractName: event.contractName,
          contractSymbol: event.contractSymbol);
    }
  }
}
