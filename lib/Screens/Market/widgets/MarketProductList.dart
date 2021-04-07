import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3front/Logic/Items/SelectItem/cubit/select_item_cubit.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Routes/RouteName.dart';

import 'MarketProductListItem.dart';

class MarketProductList extends StatelessWidget {
  final List<ItemsModel> items;
  const MarketProductList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: EdgeInsets.fromLTRB(16, 4, 16, 16),

          /// Product List Box
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            child: ResponsiveGridView.builder(
              itemCount: this.items.length,
              gridDelegate: ResponsiveGridDelegate(
                  minCrossAxisExtent: 80,
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12),
              itemBuilder: (context, index) {
                return Card(
                  /// Gesture detector, navigate to item detail
                  child: InkWell(
                    onTap: () {
                      context
                          .read<SelectItemCubit>()
                          .selectItem(selectedItem: items[index]);
                      Navigator.of(context).pushNamed(RouteName.itemDetail);
                    },
                    child: MarketProductListItem(
                      item: items[index],
                      constraints: constraints,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
