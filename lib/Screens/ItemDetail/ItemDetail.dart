import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:web3front/Logic/Items/SaleItem/bloc/sale_item_bloc.dart';
import 'package:web3front/Logic/Items/SelectItem/cubit/select_item_cubit.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Screens/ItemDetail/widgets/ItemDetailDescription.dart';
import 'package:web3front/Screens/ItemDetail/widgets/ItemDetailImage.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Refresh the Screen after build
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!(context.read<SelectItemCubit>().state is SelectItemSelected)) {
        String? rawItem = window.localStorage['selectedItem'];
        if (rawItem != null) {
          context
              .read<SelectItemCubit>()
              .selectItem(selectedItem: ItemsModel.fromRawJson(rawItem));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectItemCubit, SelectItemState>(
      builder: (context, state) {
        if (state is SelectItemSelected) {
          final ItemsModel item = state.selectedItem;
          return Scaffold(
            appBar: AppBar(
              title: Text(item.name),
            ),
            body: Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ResponsiveRowColumn(
                        rowColumn: constraints.maxWidth < 800 ? false : true,
                        rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        columnSpacing: 10,
                        children: [
                          ResponsiveRowColumnItem(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: constraints.maxWidth < 800
                                  ? constraints.maxWidth
                                  : constraints.maxWidth * 0.36,
                              child: ItemDetailImage(
                                item: item,
                              ),
                            ),
                          ),
                          ResponsiveRowColumnItem(
                            child: constraints.maxWidth < 800
                                ? Divider()
                                : VerticalDivider(),
                          ),
                          ResponsiveRowColumnItem(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                border: constraints.maxWidth < 800
                                    ? null
                                    : Border(
                                        left: BorderSide(
                                          color: Colors.black,
                                          width: 0.5,
                                        ),
                                      ),
                              ),
                              width: constraints.maxWidth < 800
                                  ? constraints.maxWidth
                                  : constraints.maxWidth * 0.6,
                              child: Container(
                                child: ItemDetailDescriptionScreen(
                                  item: item,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold();
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
