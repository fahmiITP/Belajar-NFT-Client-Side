import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:web3front/Logic/Items/BurnItem/bloc/burn_item_bloc.dart';
import 'package:web3front/Logic/Items/SaleItem/bloc/sale_item_bloc.dart';
import 'package:web3front/Logic/Items/TransferItem/bloc/transfer_item_bloc.dart';

import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Screens/ItemDetail/widgets/ItemDetailDescriptionTradePrice.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              item: widget.item,
              priceTextController: priceTextController,
            ),

            SizedBox(height: 20),

            /// Buy or Sell Button
            Builder(
              builder: (context) {
                if (ethereum.selectedAddress! == widget.item.tokenOwner &&
                    widget.item.isOnSale == 0) {
                  return Container(
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () {
                          print(ethereum.selectedAddress);
                        },
                        child: Text("Sell")),
                  );
                } else if (ethereum.selectedAddress! ==
                        widget.item.tokenOwner &&
                    widget.item.isOnSale == 1) {
                  return Wrap(children: [
                    /// Cancel Sell
                    Container(
                      width: 200,
                      margin: EdgeInsets.all(4),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SaleItemBloc>().add(SaleItemCancelStart(
                              contractAddress: widget.item.contractAddress,
                              tokenId: widget.item.tokenId));
                        },
                        child: Text("Cancel the Sale"),
                      ),
                    ),

                    /// Transfer Token
                    Container(
                      width: 200,
                      margin: EdgeInsets.all(4),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return Colors.green;
                            },
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  width: 200,
                                  height: 150,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText:
                                                "Enter Destination Address Here",
                                            hintStyle: TextStyle(fontSize: 14)),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return Colors.green;
                                            },
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        child: Text("Transfer Token"),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          // context.read<TransferItemBloc>().add(
                          //       TransferItemStart(
                          //           tokenId: widget.item.tokenId, newOwner: newOwner),
                          //     );
                        },
                        child: Text("Transfer the Token"),
                      ),
                    ),

                    /// Burn Token
                    Container(
                      width: 200,
                      margin: EdgeInsets.all(4),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return Colors.red;
                            },
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Burn Token"),
                          ));
                        },
                        child: Text("Burn the Token"),
                      ),
                    ),
                  ]);
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
