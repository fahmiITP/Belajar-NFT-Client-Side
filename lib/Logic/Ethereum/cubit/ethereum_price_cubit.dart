import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web3front/Global/Endpoints.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'ethereum_price_state.dart';

class EthereumPriceCubit extends Cubit<EthereumPriceState> {
  late StreamSubscription ethPriceStream;

  /// Connect to coincap websocket channel
  final channel =
      WebSocketChannel.connect(Uri.parse(Endpoints.ethPriceWebSocket));
  EthereumPriceCubit() : super(EthereumPriceInitial()) {
    monitorEthPrice();
  }

  /// Listen to the web socket
  StreamSubscription<dynamic> monitorEthPrice() {
    return ethPriceStream = channel.stream.listen((event) {
      /// Get ethereum price
      final price = jsonDecode(event)["ethereum"];

      /// Emit new state
      emit(EthereumPriceCurrent(price));
    });
  }

  @override
  Future<void> close() {
    ethPriceStream.cancel();
    channel.sink.close();
    return super.close();
  }
}
