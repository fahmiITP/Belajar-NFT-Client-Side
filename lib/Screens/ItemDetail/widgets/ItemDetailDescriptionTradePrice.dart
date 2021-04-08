import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';

class ItemDetailDescriptionTradePrice extends StatefulWidget {
  final ItemsModel item;
  final Function(String) onChanged;
  const ItemDetailDescriptionTradePrice({
    Key? key,
    required this.item,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ItemDetailDescriptionTradePriceState createState() =>
      _ItemDetailDescriptionTradePriceState();
}

class _ItemDetailDescriptionTradePriceState
    extends State<ItemDetailDescriptionTradePrice> {
  TextEditingController priceTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (ethereum.selectedAddress!.toLowerCase() ==
            widget.item.tokenOwner.toLowerCase()) {
          if (widget.item.isOnSale == 0) {
            return TextField(
              controller: priceTextController,
              maxLength: 20,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
              ],
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                counterText: "",
                prefixText: "ETH ",
              ),
            );
          } else {
            return SelectableText(
              "${Utils.formatEther(widget.item.price!.toString())} ETH",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            );
          }
        } else {
          if (ethereum.selectedAddress!.toLowerCase() !=
                  widget.item.tokenOwner.toLowerCase() &&
              widget.item.isOnSale == 1) {
            return SelectableText(
              "${Utils.formatEther(widget.item.price!.toString())} ETH",
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

  @override
  void dispose() {
    this.priceTextController.dispose();
    super.dispose();
  }
}
