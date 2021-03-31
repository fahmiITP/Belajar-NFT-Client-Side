import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:web3front/Services/encode_contract.dart';
import 'package:web3front/Services/get_contract_abi.dart';
import 'package:web3front/Services/get_contract_bytecode.dart';
import 'package:web3front/Web3_Provider/ethers.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/main.dart';

class Menus extends StatefulWidget {
  Menus({Key? key}) : super(key: key);

  @override
  _MenusState createState() => _MenusState();
}

class _MenusState extends State<Menus> {
  Contract? currentContract;
  String getBalance = "0";
  String rinkebyBalance = "0";
  String deployedContract = "";
  String balanceMethod = "0";
  String encodedABI = "";
  String contractBytecode = "";
  String txReceipt = "";
  String connectContract = "";
  String mintedToken = "";
  Uint8List uploadedImage = Uint8List.fromList([]);

  var rinkeby = JsonRpcProvider(
      'https://rinkeby.infura.io/v3/ee940eb70e2a42cda454bcd454a28e3f');
  var web3 = Web3Provider(ethereum);
  var contract;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GridView.count(
          crossAxisCount:
              3, // Generate 100 widgets that display their index in the List.
          children: [
            methodCaller(
              onPress: () async {
                if (ethereum.isConnected()) {
                  final balance = await promiseToFuture(
                      web3.getBalance(ethereum.selectedAddress!));
                  setState(() {
                    this.getBalance = balance.toString();
                  });
                } else {
                  Flushbar(
                    duration: Duration(seconds: 2),
                    message: "Metamask isn't Connected",
                  )..show(context);
                }
              },
              buttonName: "Get Balance",
              result: getBalance,
            ),
            methodCaller(
              onPress: () async {
                if (ethereum.isConnected()) {
                  final balance = await promiseToFuture(
                      rinkeby.getBalance(ethereum.selectedAddress!));
                  setState(() {
                    this.rinkebyBalance = balance.toString();
                  });
                } else {
                  Flushbar(
                    duration: Duration(seconds: 2),
                    message: "Metamask isn't Connected",
                  )..show(context);
                }
              },
              buttonName: "Get Rinkeby Balance",
              result: this.rinkebyBalance,
            ),

            /// Deploy Contract Transaction
            methodCaller(
              onPress: () async {
                if (ethereum.isConnected()) {
                  final deploy = await promiseToFuture(
                    web3.getSigner().sendTransaction(
                          TxParams(
                              data: this.contractBytecode + this.encodedABI),
                        ),
                  );
                  setState(() {
                    this.deployedContract = stringify(deploy);
                  });
                } else {
                  Flushbar(
                    duration: Duration(seconds: 2),
                    message: "Metamask isn't Connected",
                  )..show(context);
                }
              },
              buttonName: "Deploy Contract",
              result: this.deployedContract,
            ),

            methodCaller(
              onPress: () async {
                if (ethereum.isConnected()) {
                  final balance = await promiseToFuture(
                    ethereum.request(
                      RequestParams(
                          method: 'eth_getBalance',
                          params: [ethereum.selectedAddress]),
                    ),
                  );
                  setState(() {
                    this.balanceMethod = balance.toString();
                  });
                } else {
                  Flushbar(
                    duration: Duration(seconds: 2),
                    message: "Metamask isn't Connected",
                  )..show(context);
                }
              },
              buttonName: "Balance Method",
              result: this.balanceMethod,
            ),

            /// Get Encoded ABI
            methodCaller(
              onPress: () async {
                final encodedABI = await EncodeContract()
                    .getEncodedAbi(contractName: "Test", contractSymbol: "TST");

                setState(() {
                  this.encodedABI = encodedABI ?? "Failed to Fetch Data";
                });
              },
              buttonName: "Encode ABI",
              result: this.encodedABI,
            ),

            /// Get Contract Bytecode
            methodCaller(
              onPress: () async {
                final bytecode = await GetContractByteCode().getBytecode();

                setState(() {
                  this.contractBytecode = bytecode ?? "Failed to Fetch Data";
                });
              },
              buttonName: "Get Contract Bytecode",
              result: this.contractBytecode,
            ),

            /// Connect to already deployed contract
            methodCaller(
              onPress: () async {
                /// Get Human Readable ABI
                final abi = await GetContractAbi().getUserContractAbi();

                /// Create a new Contract instance
                final contract = Contract(
                    '0x83b2a0889c238a0172103a1f8b3511e67c00bfa5',
                    abi ?? [],
                    web3);

                /// Assign metamask signer to the contract (so we can perform a transaction)
                late final currentContract = contract.connect(web3.getSigner());

                /// Get Contract Name
                var contractName = "";
                contractName = await promiseToFuture(currentContract.name());

                setState(() {
                  this.currentContract = currentContract;
                  this.connectContract = contractName;
                });
              },
              buttonName: "Connect Contract",
              result: this.connectContract,
            ),

            /// Mint Token
            methodCaller(
              onPress: () async {
                if (this.currentContract == null) {
                  Flushbar(
                    duration: Duration(seconds: 2),
                    message: "Please Connect to a Contract First",
                  )..show(context);
                } else {
                  /// Total Token
                  final totalToken = await promiseToFuture(
                      callMethod(this.currentContract!, 'totalToken', []));

                  /// New Token
                  final rawTotalToken = jsonDecode(stringify(totalToken));
                  final parsedTotalToken = int.parse(rawTotalToken['hex']);
                  final newToken = parsedTotalToken + 1;

                  /// Mint Token
                  final mintToken = await promiseToFuture(callMethod(
                      this.currentContract!, 'mint', [
                    ethereum.selectedAddress,
                    newToken,
                    'https://www.twitter.com'
                  ]));

                  setState(() {
                    this.mintedToken = stringify(mintToken);
                  });
                }
              },
              buttonName: "Mint Token",
              result: this.mintedToken,
            ),

            /// Get Transaction Receipt
            methodCaller(
              onPress: () async {
                final receipt = await promiseToFuture(rinkeby.getTransactionReceipt(
                    '0xf6f016f92f915577c76868675856f30e481513847cd674f4c4bfb8dd6d187152'));
                setState(() {
                  this.txReceipt = stringify(receipt);
                });
              },
              buttonName: "Get Transaction Receipt",
              result: this.txReceipt,
            ),

            /// Upload Image
            methodCaller(
                onPress: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image,
                    allowMultiple: false,
                  );

                  if (result != null) {
                    setState(() {
                      this.uploadedImage = result.files.single.bytes!;
                    });
                  } else {
                    print("Error");
                  }
                },
                buttonName: "Upload Image",
                result: this.uploadedImage,
                isImage: true),
          ],
        ),
      ),
    );
  }

  Widget methodCaller(
      {required VoidCallback onPress,
      required String buttonName,
      required dynamic result,
      bool? isImage}) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onPress,
              child: Text(
                buttonName,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              child: isImage ?? false
                  ? Image.memory(result)
                  : SelectableText("Result : " + result.toString()),
            )
          ],
        ),
      ),
    );
  }
}
