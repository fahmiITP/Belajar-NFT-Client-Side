import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:web3front/Global/LocalStorageConstant.dart';

part 'contract_select_state.dart';

class ContractSelectCubit extends Cubit<ContractSelectState> {
  ContractSelectCubit() : super(ContractSelectInitial());

  void selectContract({required String contractAddress}) {
    window.localStorage[LocalStorageConstant.selectedContract] =
        contractAddress;
    emit(ContractSelectSelected(contractAddress: contractAddress));
  }
}
