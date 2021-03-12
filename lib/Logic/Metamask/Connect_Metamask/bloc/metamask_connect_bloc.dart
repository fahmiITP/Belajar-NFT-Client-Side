import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:js/js_util.dart';
import 'package:web3front/Helpers/ChainIDConverter.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/main.dart';

part 'metamask_connect_event.dart';
part 'metamask_connect_state.dart';

class MetamaskConnectBloc
    extends Bloc<MetamaskConnectEvent, MetamaskConnectState> {
  MetamaskConnectBloc() : super(MetamaskConnectInitial());

  @override
  Stream<MetamaskConnectState> mapEventToState(
    MetamaskConnectEvent event,
  ) async* {
    if (event is MetamaskConnectStart) {
      try {
        final chainId = await promiseToFuture(
          ethereum.request(
            RequestParams(method: 'eth_chainId'),
          ),
        );

        if (chainId == "0x4") {
          await promiseToFuture(
            ethereum.request(
              RequestParams(method: 'eth_requestAccounts'),
            ),
          );

          yield MetamaskConnectSuccess();
        } else {
          yield MetamaskConnectFailed(
              error:
                  "You are currently on ${ChainIDConverter.convertToString(chainIdHex: chainId)}, Please change your network to Rinkeby");
        }
      } catch (e) {
        yield MetamaskConnectFailed(
            error: "Error : " + jsonDecode(stringify(e))['message'].toString());
      }
    }
  }
}
