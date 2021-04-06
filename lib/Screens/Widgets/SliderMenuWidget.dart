import 'package:flutter/material.dart';
import 'package:web3front/Global/CustomTextStyle.dart';
import 'package:web3front/Routes/RouteName.dart';

class SliderMenuWidget extends StatelessWidget {
  final Function(String)? onItemClick;

  const SliderMenuWidget({Key? key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            height: 59,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Menu",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.shade300,
          ),
          SizedBox(
            height: 20,
          ),
          sliderItem('Home', Icons.home, context, () {
            Navigator.of(context).pushNamed(RouteName.homeRoute);
          }),
          sliderItem(
              'Create Contract and Item', Icons.library_add_outlined, context,
              () {
            if (!(ModalRoute.of(context)?.settings.name ==
                RouteName.contractForm)) {
              Navigator.of(context).pushNamed(RouteName.contractForm);
            }
          }),
          sliderItem('My Items', Icons.photo_library_outlined, context, () {
            if (!(ModalRoute.of(context)?.settings.name == RouteName.myItems)) {
              Navigator.of(context).pushNamed(RouteName.myItems);
            }
          }),
          sliderItem('Market', Icons.shopping_cart_outlined, context, () {
            if (!(ModalRoute.of(context)?.settings.name == RouteName.market)) {
              Navigator.of(context).pushNamed(RouteName.market);
            }
          }),
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons, BuildContext context,
      VoidCallback onPress) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4),
      height: 50,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          alignment: Alignment.centerLeft,
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.all(24),
          ),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.blue.shade300;
            } else {
              return Colors.white;
            }
          }),
          foregroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
        ),
        onPressed: onPress,
        icon: Icon(icons),
        label: Text(
          title,
        ),
      ),
    );
  }
}
