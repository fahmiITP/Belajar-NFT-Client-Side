import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';

class ItemDetailDescriptionTradePrice extends StatelessWidget {
  final ItemsModel item;
  final TextEditingController priceTextController;
  const ItemDetailDescriptionTradePrice({
    Key? key,
    required this.item,
    required this.priceTextController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (ethereum.selectedAddress == item.tokenOwner) {
          return TextField(
            controller: priceTextController,
            maxLength: 20,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
            ],
            onChanged: (value) {
              print(Utils.parseEther(value));
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              counterText: "",
              prefixText: "ETH ",
            ),
          );
        } else {
          if (item.isOnSale == 1) {
            return SelectableText(
              "${Utils.formatEther(item.price!.toString())} ETH",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            );
          } else {
            return SelectableText(
              "Not For Sale",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            );
          }
        }
      },
    );
  }
}
