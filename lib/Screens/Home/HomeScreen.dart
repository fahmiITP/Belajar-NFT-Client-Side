import 'package:flutter/material.dart';
import 'package:js/js.dart';
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
  String? chainId;

  @override
  void initState() {
    super.initState();

    // Listen on chain change
    ethereum.on("chainChanged", allowInterop((f) {
      setState(() {
        chainId = ChainIDConverter.convertToString(chainIdHex: f);
      });
    }));
    // Listen on account change
    ethereum.on("accountsChanged", allowInterop((f) {
      setState(() {});
    }));

    /// Refresh the Screen after build
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Start metamask check
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
                  chainId ??
                      ChainIDConverter.convertToString(
                          chainIdHex: state.chainId),
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
                        child: Text(ethereum.selectedAddress != null
                            ? "Navigate to Contract Creation"
                            : "Connect to Metamask Wallet"),
                        onPressed: () {
                          if (ethereum.selectedAddress != null &&
                              ethereum.isConnected()) {
                            Navigator.of(context)
                                .pushNamed(RouteName.contractForm);
                          } else {
                            context
                                .read<MetamaskConnectBloc>()
                                .add(MetamaskConnectStart());
                          }
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
                ),
                SizedBox(height: 12),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).pushNamed(RouteName.itemDetail);
                //   },
                //   child: Text("To Item detail"),
                // )
                // ElevatedButton(
                //   onPressed: () async {
                //     /// Web3 Provider
                //     final web3 = Web3Provider(ethereum);
                //     final newMessage = SellTokenMessageModel(
                //       sellerAddress: ethereum.selectedAddress!,
                //       originalContractAddress:
                //           "0xD6344c3aC9f5e083B3a4BBAe763125bb5DE46D56",
                //       price: EtherHelpers.etherToWei(ethers: 0.01),
                //       tradeMarketAddress:
                //           "0x09118A618D216b3a9e94EC7f2088D833B3641274",
                //       tokenId: "0",
                //     );

                //     final encoded = Utils.arrayify(
                //       Utils.keccak256(
                //         DefaultABICoder.encode(
                //           [
                //             'address',
                //             'address',
                //             'address',
                //             'uint256',
                //             'uint256'
                //           ],
                //           [
                //             newMessage.sellerAddress,
                //             newMessage.originalContractAddress,
                //             newMessage.tradeMarketAddress,
                //             newMessage.price,
                //             newMessage.tokenId
                //           ],
                //         ),
                //       ),
                //     );

                //     final res = await promiseToFuture(
                //         web3.getSigner().signMessage(encoded));
                //     print(stringify(res));

                //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //       content: SelectableText(res),
                //     ));
                //   },
                //   child: Text("Sign Message"),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
