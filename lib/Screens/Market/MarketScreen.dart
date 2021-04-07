import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web3front/Global/CustomTextStyle.dart';
import 'package:web3front/Logic/Market/bloc/market_items_bloc.dart';
import 'package:web3front/Screens/Market/widgets/MarketProductList.dart';
import 'package:web3front/Screens/Widgets/SliderMenuWidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketScreen extends StatefulWidget {
  MarketScreen({Key? key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();

    /// Refresh the Screen after build
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<MarketItemsBloc>().add(MarketItemsFetchStart());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
        drawerIconColor: Colors.white,
        appBarColor: Theme.of(context).primaryColor,
        title: Text(
          "Market",
          style: CustomTextStyle.appBarTitleTextStyle,
        ),
        isTitleCenter: true,
        appBarPadding: EdgeInsets.all(0),
        appBarHeight: AppBar().preferredSize.height,
        hasAppBar: true,
        sliderMenu: SliderMenuWidget(),
        sliderMain: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: BlocBuilder<MarketItemsBloc, MarketItemsState>(
            builder: (context, state) {
              if (state is MarketItemsLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is MarketItemsSuccess) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: ResponsiveRowColumn(
                    rowColumn: false,
                    children: [
                      /// Sort Dropdown
                      ResponsiveRowColumnItem(
                        child: Container(
                          alignment: MediaQuery.of(context).size.width < 800
                              ? Alignment.center
                              : Alignment.centerRight,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          height: 50,
                          child: DropdownButton<String>(
                            elevation: 4,
                            value: dropdownValue,
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                            hint: Text("Sort"),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                /// Set state new value for Dropdown view
                                setState(() {
                                  dropdownValue = newValue;
                                });

                                /// Sort the items
                                if (newValue == "Lowest Price") {
                                  context.read<MarketItemsBloc>().add(
                                        MarketItemsSort(
                                            items: state.itemList,
                                            sortType:
                                                MarketItemSortType.PRICE_LOW),
                                      );
                                } else {
                                  context.read<MarketItemsBloc>().add(
                                        MarketItemsSort(
                                            items: state.itemList,
                                            sortType:
                                                MarketItemSortType.PRICE_HIGH),
                                      );
                                }
                              }
                            },
                            items: <String>['Lowest Price', 'Highest Price']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      /// Market Product List
                      ResponsiveRowColumnItem(
                        columnFlex: 1,
                        child: MarketProductList(
                          items: state.itemList.items,
                        ),
                      )
                    ],
                  ),
                );
              } else if (state is MarketItemsFailed) {
                return Center(child: Text(state.error));
              } else {
                return Center(child: Text("Fatal Error"));
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
