@JS()
library stringify;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js/js.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:web3front/Logic/Contracts/ContractForm/bloc/contract_form_bloc.dart';
import 'package:web3front/Logic/Contracts/CreateContract/bloc/contract_create_bloc.dart';
import 'package:web3front/Logic/Metamask/Check_Metamask/bloc/metamask_check_bloc.dart';
import 'package:web3front/Logic/Metamask/Connect_Metamask/bloc/metamask_connect_bloc.dart';
import 'package:web3front/Routes/GeneratedRoutes.dart';
import 'package:web3front/Routes/RouteName.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MetamaskCheckBloc()),
        BlocProvider(create: (context) => MetamaskConnectBloc()),
        BlocProvider(create: (context) => ContractFormBloc()),
        BlocProvider(create: (context) => ContractCreateBloc()),
      ],
      child: MaterialApp(
        title: 'Learn NFT',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: Routes.generateRoute,
        builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: 2460,
          minWidth: 400,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.autoScale(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
        ),
        initialRoute: RouteName.homeRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

@JS('JSON.stringify')
external String stringify(Object obj);
