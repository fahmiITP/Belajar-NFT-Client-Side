import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web3front/Logic/Items/SaleItem/bloc/sale_item_bloc.dart';
import 'package:web3front/Logic/Items/TransferItem/bloc/transfer_item_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';

class CustomDialog extends StatefulWidget {
  final ItemsModel item;
  final VoidCallback burnCallback;
  final VoidCallback transferCallback;
  const CustomDialog({
    Key? key,
    required this.item,
    required this.burnCallback,
    required this.transferCallback,
  }) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemName = widget.item.name;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 360,
        width: 200,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: ResponsiveRowColumn(
          rowColumn: false,
          columnSpacing: 20,
          children: [
            ResponsiveRowColumnItem(
              child: InkWell(
                onTap: widget.burnCallback,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red),
                  child: Center(
                    child: Text(
                      "Burn '$itemName'",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            /// Put on Sale the Item
            // ResponsiveRowColumnItem(
            //   child: InkWell(
            //     onTap: () async {
            //       Navigator.of(context, rootNavigator: true).pop();
            //       context
            //           .read<SaleItemBloc>()
            //           .add(SaleItemStart(tokenId: widget.item['token_id']));
            //     },
            //     child: Container(
            //       height: 50,
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           color: Colors.orange),
            //       child: Center(
            //         child: Text(
            //           "Put On Sale '$itemName'",
            //           style: TextStyle(color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            ResponsiveRowColumnItem(
              child: Container(
                height: 50,
                width: double.infinity,
                child: Center(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      labelText: "New Owner Address",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            ResponsiveRowColumnItem(
              child: InkWell(
                onTap: () {
                  if (textEditingController.text != "") {
                    Navigator.of(context, rootNavigator: true).pop();
                    // context.read<TransferItemBloc>().add(
                    //       TransferItemStart(
                    //           tokenId: widget.item.tokenId,
                    //           newOwner: textEditingController.text,
                    //           contractAddress: widget.item.contractAddress),
                    //     );
                  }
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green),
                  child: Center(
                    child: Text(
                      "Transfer '$itemName'",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            ResponsiveRowColumnItem(
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green),
                  child: Center(
                    child: Text(
                      "Sell '$itemName'",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            ResponsiveRowColumnItem(
              child: InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Cancel",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    this.textEditingController.dispose();
    super.dispose();
  }
}
