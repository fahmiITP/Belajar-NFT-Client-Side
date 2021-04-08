import 'package:flutter/material.dart';
import 'package:web3front/Logic/Items/TransferItem/bloc/transfer_item_bloc.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetailTransferDialog extends StatefulWidget {
  final ItemsModel item;
  const ItemDetailTransferDialog({Key? key, required this.item})
      : super(key: key);

  @override
  _ItemDetailTransferDialogState createState() =>
      _ItemDetailTransferDialogState();
}

class _ItemDetailTransferDialogState extends State<ItemDetailTransferDialog> {
  ItemsModel get item => widget.item;
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Destination Address Here",
                hintStyle: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return Colors.green;
                    },
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<TransferItemBloc>().add(TransferItemStart(
                      tokenId: item.tokenId,
                      newOwner: _controller.text,
                      contractAddress: item.contractAddress,
                      item: item));
                },
                child: Text("Transfer Token"),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }
}
