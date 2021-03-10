import 'package:flutter/material.dart';
import 'package:web3front/Routes/RouteName.dart';
import 'package:web3front/Screens/Menus.dart';
import 'package:web3front/main.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.homeRoute:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case RouteName.menu:
        return MaterialPageRoute(builder: (_) => Menus());
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
