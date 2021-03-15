import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'contract_select_state.dart';

class ContractSelectCubit extends Cubit<ContractSelectState> {
  ContractSelectCubit() : super(ContractSelectInitial());

  void selectContract({required String contractAddress}) =>
      emit(ContractSelectSelected(contractAddress: contractAddress));
}
