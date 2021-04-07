import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web3front/Helpers/EtherHelpers.dart';
import 'package:web3front/Logic/Ethereum/cubit/ethereum_price_cubit.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';

class MarketProductListItem extends StatelessWidget {
  final ItemsModel item;
  final BoxConstraints constraints;
  const MarketProductListItem(
      {Key? key, required this.item, required this.constraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveRowColumn(
      columnMainAxisAlignment: MainAxisAlignment.start,
      columnCrossAxisAlignment: CrossAxisAlignment.center,
      rowColumn: false,
      children: [
        ResponsiveRowColumnItem(
          columnFlex: 8,
          child: Container(
            width: double.infinity,
            height: 300,
            color: Colors.white,
            child: Builder(
              builder: (context) {
                if (item.image.contains("https://")) {
                  return Image.network(
                    item.image,
                  );
                } else {
                  return Image.memory(base64Decode(item.image));
                }
              },
            ),
          ),
        ),

        /// Margin
        ResponsiveRowColumnItem(child: SizedBox(height: 16)),

        /// Title
        ResponsiveRowColumnItem(
          columnFlex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              item.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: constraints.maxWidth < 800 ? 14 : 16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),

        /// Margin
        ResponsiveRowColumnItem(child: SizedBox(height: 8)),

        /// Description
        ResponsiveRowColumnItem(
          columnFlex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              item.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: constraints.maxWidth < 800 ? 12 : 16,
              ),
            ),
          ),
        ),

        /// Margin
        ResponsiveRowColumnItem(child: SizedBox(height: 8)),

        /// Price
        ResponsiveRowColumnItem(
          columnFlex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<EthereumPriceCubit, EthereumPriceState>(
              builder: (context, state) {
                if (state is EthereumPriceInitial) {
                  return Text(
                    "ETH : " +
                        EtherHelpers.weiToEthers(wei: item.price!).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: constraints.maxWidth < 800 ? 12 : 18,
                    ),
                  );
                } else if (state is EthereumPriceCurrent) {
                  final String itemPrice =
                      EtherHelpers.weiToEthers(wei: item.price!);
                  final double itemPriceDouble = double.parse(itemPrice);
                  final double ethPrice = double.parse(state.price);
                  return Text(
                    "ETH : $itemPrice (\$${(ethPrice * itemPriceDouble).toStringAsFixed(3)})",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: constraints.maxWidth < 800 ? 12 : 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                } else {
                  return Text("Fatal Error");
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
