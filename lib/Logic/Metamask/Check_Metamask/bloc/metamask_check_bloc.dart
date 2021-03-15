import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:js/js_util.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';

part 'metamask_check_event.dart';
part 'metamask_check_state.dart';

class MetamaskCheckBloc extends Bloc<MetamaskCheckEvent, MetamaskCheckState> {
  MetamaskCheckBloc() : super(MetamaskCheckInitial());

  @override
  Stream<MetamaskCheckState> mapEventToState(
    MetamaskCheckEvent event,
  ) async* {
    if (event is MetamaskCheckStart) {
      if (ethereum != null) {
        final chainId = await promiseToFuture(
            ethereum.request(RequestParams(method: 'eth_chainId')));
        yield MetamaskCheckInstalled(ethereum, chainId);
      } else {
        yield MetamaskCheckNotInstalled();
      }
    }
  }
}
