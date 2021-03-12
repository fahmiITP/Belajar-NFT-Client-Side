import 'package:flutter/material.dart';
import 'package:web3front/Routes/RouteName.dart';
import 'package:web3front/Screens/ContractCreation/ContractCreation.dart';
import 'package:web3front/Screens/Home/HomeScreen.dart';
import 'package:web3front/Screens/Menus.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.homeRoute:
        return MaterialPageRoute(
            builder: (_) => MyHomePage(
                  title: "Home Page",
                ),
            settings: settings);
      case RouteName.menu:
        return MaterialPageRoute(builder: (_) => Menus(), settings: settings);
      case RouteName.contractForm:
        return MaterialPageRoute(
            builder: (_) => ContractCreation(), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
