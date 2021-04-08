import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web3front/Logic/Items/MyItems/bloc/my_items_bloc.dart';
import 'package:web3front/Logic/Items/SelectItem/cubit/select_item_cubit.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Routes/RouteName.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyItemsListView extends StatelessWidget {
  final MyItemsSuccess state;
  final int contractIndex;
  const MyItemsListView(
      {Key? key, required this.state, required this.contractIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: state.myItems[contractIndex].item.length,
      itemBuilder: (context, index) {
        return Container(
          height: 155,
          width: 155,
          child: Card(
            elevation: 8,
            child: InkWell(
              onTap: () {
                /// Convert data model
                final data = state.myItems[contractIndex].item[index];
                final item = ItemsModel(
                    contractAddress: data.contractAddress,
                    description: data.description,
                    id: data.id,
                    image: data.image,
                    name: data.name,
                    tokenId: data.tokenId,
                    tokenOwner: data.ownerAddress,
                    isOnSale: data.isOnSale,
                    price: data.price);

                /// Select the item and navigate
                context.read<SelectItemCubit>().selectItem(selectedItem: item);
                Navigator.of(context).pushNamed(RouteName.itemDetail);
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Center(
                      child: Builder(
                        builder: (context) {
                          if (!state.myItems[contractIndex].item[index].image
                              .toString()
                              .contains("https://")) {
                            return Image.memory(base64Decode(state
                                .myItems[contractIndex].item[index].image));
                          } else {
                            return Image.network(
                                state.myItems[contractIndex].item[index].image);
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.8),
                        child: Text(
                          state.myItems[contractIndex].item[index].name,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
