import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:web3front/Global/UserContractABI.dart';

import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'ItemDetailDescriptionTrade.dart';

class ItemDetailDescriptionScreen extends StatelessWidget {
  final ItemsModel item;
  const ItemDetailDescriptionScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: FutureBuilder(
              future: promiseToFuture(getCurrentContract(item).name()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () {
                      html.window.open(
                          'https://rinkeby.etherscan.io/address/${item.contractAddress}',
                          "Rinkeby");
                    },
                    child: Text(
                      snapshot.data.toString(),
                      style: TextStyle(color: Colors.blue),
                    ),
                  );
                } else {
                  return Text(
                    item.contractAddress,
                    style: TextStyle(color: Colors.blue),
                  );
                }
              },
            ),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Owned by: "),
                  TextSpan(
                      text: item.tokenOwner,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => html.window.open(
                            'https://rinkeby.etherscan.io/address/${item.tokenOwner}',
                            "Rinkeby"),
                      style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            child: SelectableText(
              item.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            child: SelectableText(item.description),
          ),
          SizedBox(
            height: 12,
          ),
          ItemDetailDescriptionTrade(item: item),
        ],
      ),
    );
  }

  Contract getCurrentContract(ItemsModel item) {
    /// Web3 Provider
    final web3 = Web3Provider(ethereum);

    /// Create a new Contract instance
    final contract = Contract(item.contractAddress, UserContractABI.abi, web3);

    /// Assign metamask signer to the contract (so we can perform a transaction)
    final currentContract = contract.connect(web3.getSigner());

    return currentContract;
  }
}
