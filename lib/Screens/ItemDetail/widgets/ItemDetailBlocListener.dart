import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3front/Logic/Items/BurnItem/bloc/burn_item_bloc.dart';
import 'package:web3front/Logic/Items/ItemList/bloc/item_list_bloc.dart';
import 'package:web3front/Logic/Items/SaleItem/bloc/sale_item_bloc.dart';
import 'package:web3front/Logic/Items/TransferItem/bloc/transfer_item_bloc.dart';

class ItemDetailBlocListener extends StatelessWidget {
  const ItemDetailBlocListener({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaleItemBloc, SaleItemState>(
      listener: (context, state) {
        if (state is SaleItemLoading) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("${state.progress}/${state.totalProgress} ${state.step}"),
            duration: Duration(days: 1),
          ));
        } else if (state is SaleItemSuccess) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${state.message}, Token ID : ${state.tokenId}"),
            duration: Duration(seconds: 5),
          ));
        } else if (state is SaleItemFailed) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${state.error}"),
            duration: Duration(seconds: 5),
          ));
        }
      },
      child: BlocListener<TransferItemBloc, TransferItemState>(
        listener: (context, state) {
          if (state is TransferItemLoading) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "${state.progress}/${state.totalProgress} ${state.step}"),
              duration: Duration(days: 1),
            ));
          } else if (state is TransferItemSuccess) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Token Transfered Successfully, Token ID : ${state.tokenId}"),
              duration: Duration(seconds: 5),
            ));

            /// Remove token from item list
            if (context.read<ItemListBloc>().state is ItemListFetchSuccess) {
              (context.read<ItemListBloc>().state as ItemListFetchSuccess)
                  .tokenList
                  .items
                  .removeWhere(
                      (element) => element.tokenId.toString() == state.tokenId);
            }
          } else if (state is TransferItemFailed) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${state.error}"),
              duration: Duration(seconds: 5),
            ));
          }
        },
        child: BlocListener<BurnItemBloc, BurnItemState>(
          listener: (context, state) {
            if (state is BurnItemLoading) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "${state.progress}/${state.totalProgress} ${state.step}"),
                duration: Duration(days: 1),
              ));
            } else if (state is BurnItemSuccess) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Token Burnt Successfully, Token ID : ${state.tokenId}"),
                duration: Duration(seconds: 5),
              ));

              /// Remove token from item list
              if (context.read<ItemListBloc>().state is ItemListFetchSuccess) {
                (context.read<ItemListBloc>().state as ItemListFetchSuccess)
                    .tokenList
                    .items
                    .removeWhere((element) =>
                        element.tokenId.toString() == state.tokenId);
              }
            } else if (state is BurnItemFailed) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${state.error}"),
                duration: Duration(seconds: 5),
              ));
            }
          },
          child: Container(),
        ),
      ),
    );
  }
}
