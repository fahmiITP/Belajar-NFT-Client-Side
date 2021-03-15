import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js/js_util.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web3front/Logic/Items/BurnItem/bloc/burn_item_bloc.dart';
import 'package:web3front/Logic/Items/ItemList/bloc/item_list_bloc.dart';
import 'package:web3front/Routes/RouteName.dart';
import 'package:web3front/Screens/Widgets/CustomDialog.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';

class ItemCreationList extends StatefulWidget {
  const ItemCreationList({Key? key}) : super(key: key);

  @override
  _ItemCreationListState createState() => _ItemCreationListState();
}

class _ItemCreationListState extends State<ItemCreationList> {
  var web3 = Web3Provider(ethereum);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 500,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80,
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeData().primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Your Tokens",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: BlocBuilder<ItemListBloc, ItemListState>(
                    builder: (context, state) {
                      if (state is ItemListFetchSuccess) {
                        if (state.tokenList.isNotEmpty) {
                          return ResponsiveGridView.builder(
                            alignment: Alignment.center,
                            itemCount: state.tokenList.length,
                            gridDelegate: ResponsiveGridDelegate(
                              crossAxisExtent: 155,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              /// Widget
                              return Card(
                                elevation: 8,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomDialog(
                                          item: state.tokenList[index],
                                          burnCallback: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            context.read<BurnItemBloc>().add(
                                                BurnItemStart(
                                                    tokenId:
                                                        state.tokenList[index]
                                                            ['token_id']));
                                          },
                                          transferCallback: () {},
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.memory(base64Decode(
                                              state.tokenList[index]['image'])),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            width: double.infinity,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            child: Text(
                                              state.tokenList[index]['name'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text("No Tokens Available"),
                          );
                        }
                      } else if (state is ItemListFetchLoading) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: Text("Error"),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
