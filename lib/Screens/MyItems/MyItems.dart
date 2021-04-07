import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:web3front/Global/CustomTextStyle.dart';
import 'package:web3front/Logic/Items/MyItems/bloc/my_items_bloc.dart';
import 'package:web3front/Screens/MyItems/widgets/MyItemsListView.dart';
import 'package:web3front/Screens/Widgets/SliderMenuWidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyItems extends StatefulWidget {
  MyItems({Key? key}) : super(key: key);

  @override
  _MyItemsState createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<MyItemsBloc>().add(MyItemsFetch());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
        drawerIconColor: Colors.white,
        appBarColor: Theme.of(context).primaryColor,
        title: Text(
          "My Items",
          style: CustomTextStyle.appBarTitleTextStyle,
        ),
        isTitleCenter: true,
        appBarPadding: EdgeInsets.all(0),
        appBarHeight: 60,
        hasAppBar: true,
        sliderMenu: SliderMenuWidget(),
        sliderMain: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<MyItemsBloc, MyItemsState>(
            builder: (context, state) {
              if (state is MyItemsSuccess) {
                return Center(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      );
                    },
                    itemCount: state.myItems.length,
                    itemBuilder: (context, contractIndex) {
                      return ExpandablePanel(
                        header: Container(
                          height: 50,
                          child: Text(
                            "${state.myItems[contractIndex].contractName} (${state.myItems[contractIndex].contractAddress})",
                            textAlign: TextAlign.center,
                          ),
                          alignment: Alignment.center,
                        ),
                        collapsed: Container(),
                        expanded: Container(
                          height: 155,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyItemsListView(
                              state: state,
                              contractIndex: contractIndex,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is MyItemsFailed) {
                return Center(
                  child: Column(
                    children: [
                      IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            context.read<MyItemsBloc>().add(MyItemsFetch());
                          }),
                      SizedBox(
                        height: 8,
                      ),
                      Text(state.error),
                    ],
                  ),
                );
              } else if (state is MyItemsLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center();
              }
            },
          ),
        ),
      ),
    );
  }
}
