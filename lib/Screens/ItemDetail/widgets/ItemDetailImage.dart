import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:web3front/Model/Items/ItemsModel.dart';

class ItemDetailImage extends StatelessWidget {
  final ItemsModel item;
  const ItemDetailImage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 400,
      child: Builder(
        builder: (context) {
          if (item.image.contains("https://")) {
            return Image.network(item.image);
          } else {
            return Image.memory(base64Decode(item.image));
          }
        },
      ),
    );
  }
}
