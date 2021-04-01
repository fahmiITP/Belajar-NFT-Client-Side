import 'package:flutter/material.dart';
import 'package:js/js.dart';

import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Screens/ItemDetail/widgets/ItemDetailDescriptionTradePrice.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';

class ItemDetailDescriptionTrade extends StatefulWidget {
  final ItemsModel item;
  const ItemDetailDescriptionTrade({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _ItemDetailDescriptionTradeState createState() =>
      _ItemDetailDescriptionTradeState();
}

class _ItemDetailDescriptionTradeState
    extends State<ItemDetailDescriptionTrade> {
  TextEditingController priceTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Listen to the account change, refresh the screen if account changed
    ethereum.on("accountsChanged", allowInterop((f) {
      setState(() {});
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 0.25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              "Current Price",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            SizedBox(height: 6),

            /// Token Price Section Builder
            ItemDetailDescriptionTradePrice(
                item: widget.item, priceTextController: priceTextController),

            SizedBox(height: 20),

            /// Buy or Sell Button
            Builder(
              builder: (context) {
                if (ethereum.selectedAddress! == widget.item.tokenOwner) {
                  return Container(
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () {
                          print(ethereum.selectedAddress);
                        },
                        child: Text("Sell")),
                  );
                } else {
                  return Container(
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () {
                          print(ethereum.selectedAddress);
                        },
                        child: Text("Buy")),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
