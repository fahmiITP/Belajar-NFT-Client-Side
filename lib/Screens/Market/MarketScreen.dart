import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:web3front/Global/CustomTextStyle.dart';
import 'package:web3front/Logic/Market/bloc/market_items_bloc.dart';
import 'package:web3front/Screens/Widgets/SliderMenuWidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarketScreen extends StatefulWidget {
  MarketScreen({Key? key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
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
        appBarHeight: 60,
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
                return ListView.builder(
                  itemCount: state.itemList.items.length,
                  itemBuilder: (context, index) => Center(
                      child: SelectableText(state.itemList.items[index].name)),
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
}
