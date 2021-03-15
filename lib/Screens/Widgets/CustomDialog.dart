import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomDialog extends StatelessWidget {
  final dynamic item;
  final VoidCallback burnCallback;
  final VoidCallback transferCallback;
  const CustomDialog({
    Key? key,
    required this.item,
    required this.burnCallback,
    required this.transferCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemName = item['name'];
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
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
                onTap: burnCallback,
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
            ResponsiveRowColumnItem(
              child: InkWell(
                onTap: transferCallback,
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
}
