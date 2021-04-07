import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/main.dart';

part 'buy_item_event.dart';
part 'buy_item_state.dart';

class BuyItemBloc extends Bloc<BuyItemEvent, BuyItemState> {
  BuyItemBloc() : super(BuyItemInitial());

  @override
  Stream<BuyItemState> mapEventToState(
    BuyItemEvent event,
  ) async* {
    final int totalProgress = 4;

    /// First Loading
    yield BuyItemLoading(
      progress: 1,
      step: "Preparing Purchase Action",
      totalProgress: totalProgress,
    );

    try {} catch (e) {
      if (e.toString() == '[object Object]') {
        yield BuyItemFailed(error: jsonDecode(stringify(e))['message']);
      } else {
        yield BuyItemFailed(error: e.toString());
      }
    }
  }
}
