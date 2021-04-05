import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web3front/Logic/Items/SaleItem/bloc/sale_item_bloc.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Screens/ItemDetail/widgets/ItemDetailDescription.dart';
import 'package:web3front/Screens/ItemDetail/widgets/ItemDetailImage.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({Key? key}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final item = ItemsModel(
        id: 64,
        tokenId: 4,
        tokenOwner: "0xd6344c3ac9f5e083b3a4bbae763125bb5de46d56",
        contractAddress: "0x3611ec2e037e8057f45617c89676EE0329A79E96",
        name: "My Little Society",
        description: "Fromis_9",
        isOnSale: 1,
        price: 1000000000000,
        image:
            "https://firebasestorage.googleapis.com/v0/b/itp-nft-demo.appspot.com/o/nft-image-upload%2F0x3611ec2e037e8057f45617c89676EE0329A79E96%2F4.jpeg?alt=media&token=57cead22-d897-4c3f-a576-477bf3cf711f");
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
                        child: BlocListener<SaleItemBloc, SaleItemState>(
                          listener: (context, state) {
                            if (state is SaleItemLoading) {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "${state.progress}/${state.totalProgress} ${state.step}"),
                                duration: Duration(days: 1),
                              ));
                            } else if (state is SaleItemSuccess) {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "${state.message}. Token ID : ${state.tokenId}"),
                                duration: Duration(seconds: 5),
                              ));
                            } else if (state is SaleItemFailed) {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("${state.error}"),
                                duration: Duration(seconds: 5),
                              ));
                            }
                          },
                          child: Container(
                            child: ItemDetailDescriptionScreen(
                              item: item,
                            ),
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
  }
}
