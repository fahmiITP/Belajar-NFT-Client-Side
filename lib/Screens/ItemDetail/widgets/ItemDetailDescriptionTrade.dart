import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:web3front/Helpers/EtherHelpers.dart';
import 'package:web3front/Logic/Items/BurnItem/bloc/burn_item_bloc.dart';
import 'package:web3front/Logic/Items/SaleItem/bloc/sale_item_bloc.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Screens/ItemDetail/widgets/ItemDetailBlocListener.dart';
import 'package:web3front/Screens/ItemDetail/widgets/ItemDetailDescriptionTradePrice.dart';
import 'package:web3front/Screens/ItemDetail/widgets/ItemDetailTransferDialog.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
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
  ItemsModel get item => widget.item;
  String price = "";

  @override
  void initState() {
    super.initState();
    if (ethereum != null) {
      // Listen to the account change, refresh the screen if account changed
      ethereum.on("accountsChanged", allowInterop((f) {
        if (mounted) setState(() {});
      }));
    }
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
              onChanged: (text) {
                if (mounted)
                  setState(() {
                    this.price = text;
                  });
              },
            ),

            SizedBox(height: 20),

            /// Buy or Sell Button
            Builder(
              builder: (context) {
                if (ethereum.selectedAddress!.toLowerCase() ==
                        widget.item.tokenOwner.toLowerCase() &&
                    widget.item.isOnSale == 0) {
                  return Wrap(children: [
                    /// Sell Token
                    Container(
                      width: 200,
                      margin: EdgeInsets.all(4),
                      child: ElevatedButton(
                          onPressed: () {
                            if (price.trim().isNotEmpty) {
                              context.read<SaleItemBloc>().add(
                                    SaleItemStart(
                                      tokenId: item.tokenId,
                                      price: EtherHelpers.etherToWei(
                                        ethers: double.parse(price),
                                      ),
                                    ),
                                  );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Price Value is Invalid"),
                              ));
                            }
                          },
                          child: Text("Sell")),
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
                            builder: (context) =>
                                ItemDetailTransferDialog(item: item),
                          );
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
                          context.read<BurnItemBloc>().add(
                                BurnItemStart(tokenId: item.tokenId),
                              );
                        },
                        child: Text("Burn the Token"),
                      ),
                    ),
                  ]);
                } else if (ethereum.selectedAddress!.toLowerCase() ==
                        widget.item.tokenOwner.toLowerCase() &&
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
                            builder: (context) =>
                                ItemDetailTransferDialog(item: item),
                          );
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
                          context.read<BurnItemBloc>().add(
                                BurnItemStart(tokenId: item.tokenId),
                              );
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
            ),
            ItemDetailBlocListener(),
          ],
        ),
      ),
    );
  }
}
