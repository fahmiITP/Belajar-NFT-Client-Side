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
      child: Image.network(item.image),
    );
  }
}
