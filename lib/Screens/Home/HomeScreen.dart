import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:web3front/Helpers/ChainIDConverter.dart';
import 'package:web3front/Helpers/SnackbarHelper.dart';
import 'package:web3front/Logic/Metamask/Check_Metamask/bloc/metamask_check_bloc.dart';
import 'package:web3front/Logic/Metamask/Connect_Metamask/bloc/metamask_connect_bloc.dart';
import 'package:web3front/Routes/RouteName.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  final String? title;
  MyHomePage({Key? key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String get title => widget.title ?? "Title";

  @override
  void initState() {
    super.initState();

    /// Refresh the Screen after build
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<MetamaskCheckBloc>().add(MetamaskCheckStart());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leadingWidth: 150,
        leading: BlocBuilder<MetamaskCheckBloc, MetamaskCheckState>(
          builder: (context, state) {
            if (state is MetamaskCheckInstalled) {
              return Center(
                child: Text(
                  ChainIDConverter.convertToString(chainIdHex: state.chainId),
                ),
              );
            } else {
              return Center(child: Text("No Chain ID Detected"));
            }
          },
        ),
      ),
      body: BlocListener<MetamaskConnectBloc, MetamaskConnectState>(
        listener: (context, state) {
          if (state is MetamaskConnectSuccess) {
            Navigator.of(context).pushNamed(RouteName.contractForm);
          } else if (state is MetamaskConnectFailed) {
            SnackbarHelper.show(context: context, msg: state.error);
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<MetamaskCheckBloc, MetamaskCheckState>(
                  builder: (context, state) {
                    if (state is MetamaskCheckInstalled) {
                      return ElevatedButton(
                        child: Text("Connect to Metamask Wallet"),
                        onPressed: () {
                          context
                              .read<MetamaskConnectBloc>()
                              .add(MetamaskConnectStart());
                        },
                      );
                    } else {
                      return ElevatedButton(
                        child: Text("Please Install Metamask"),
                        onPressed: null,
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                BlocBuilder<MetamaskCheckBloc, MetamaskCheckState>(
                  builder: (context, state) {
                    if (state is MetamaskCheckInstalled) {
                      return Text(
                          ethereum.selectedAddress?.toString() ?? "None");
                    } else {
                      return Text("Metamask is not detected");
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
