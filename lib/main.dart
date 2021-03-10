@JS()
library stringify;

// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'package:js/js.dart';
import 'package:flutter/material.dart';
import 'package:web3front/Routes/GeneratedRoutes.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';

import 'Routes/RouteName.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Routes.generateRoute,
      home: MyHomePage(
        title: "Test Metamask",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? title;
  MyHomePage({Key? key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String get title => widget.title ?? "Title";
  String? selectedAddress = ethereum.selectedAddress;
  String chainId = "None";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: Center(child: Text(chainId)),
        actions: [
          Center(
            child: ElevatedButton(
              child: Text("Get Chain ID"),
              onPressed: () async {
                final chain = await promiseToFuture(
                  ethereum.request(
                    RequestParams(method: 'eth_chainId'),
                  ),
                );
                setState(() {
                  this.chainId = chain;
                });
              },
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("Connect to Metamask Wallet"),
                onPressed: () async {
                  if (ethereum.selectedAddress == this.selectedAddress &&
                      this.selectedAddress != null) {
                    Navigator.of(context).pushNamed(RouteName.menu);
                  } else {
                    await promiseToFuture(
                      ethereum.request(
                        RequestParams(method: 'eth_requestAccounts'),
                      ),
                    );
                    String se = ethereum.selectedAddress;
                    setState(() {
                      selectedAddress = se;
                    });
                  }
                },
              ),
              SizedBox(
                height: 12,
              ),
              Text(selectedAddress ?? "None")
            ],
          ),
        ),
      ),
    );
  }
}

@JS('JSON.stringify')
external String stringify(Object obj);
