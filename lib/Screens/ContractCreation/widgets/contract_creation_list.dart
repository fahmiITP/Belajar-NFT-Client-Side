import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js/js_util.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web3front/Logic/Contracts/ContractList/bloc/contract_list_bloc.dart';
import 'package:web3front/Logic/Contracts/ContractSelect/cubit/contract_select_cubit.dart';
import 'package:web3front/Logic/Contracts/CreateContract/bloc/contract_create_bloc.dart';
import 'package:web3front/Routes/RouteName.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:web3front/Web3_Provider/ethereum.dart';
import 'package:web3front/Web3_Provider/ethers.dart';

class ContractCreationList extends StatelessWidget {
  ContractCreationList({Key? key}) : super(key: key);

  /// Web3 Provider
  final web3 = Web3Provider(ethereum);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 500,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80,
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeData().primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Your Contracts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: BlocBuilder<ContractListBloc, ContractListState>(
                    builder: (context, state) {
                      if (state is ContractListFetchSuccess) {
                        return ResponsiveGridView.builder(
                          alignment: Alignment.center,
                          itemCount: state.contractList.length,
                          gridDelegate: ResponsiveGridDelegate(
                            crossAxisExtent: 155,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemBuilder: (context, index) {
                            /// Contract Address
                            final address =
                                state.contractList[index]['contract_address'];

                            /// Contract ABI
                            final abi = state.contractReadableAbi;

                            /// Create a new Contract instance
                            final contract = Contract(address, abi, web3);

                            /// Assign metamask signer to the contract (so we can perform a transaction)
                            late final currentContract =
                                contract.connect(web3.getSigner());

                            /// Widget
                            return Card(
                              elevation: 8,
                              child: InkWell(
                                onTap: context.watch<ContractCreateBloc>().state
                                        is ContractCreateLoading
                                    ? null
                                    : () {
                                        context
                                            .read<ContractSelectCubit>()
                                            .selectContract(
                                                contractAddress: address);
                                        Navigator.of(context).pushNamed(
                                          RouteName.itemForm,
                                        );
                                      },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: FutureBuilder(
                                          future: promiseToFuture(
                                              currentContract.name()),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                  snapshot.data.toString());
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error Getting Contract Data');
                                            } else {
                                              return Text(address);
                                            }
                                          },
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: PopupMenuButton<String>(
                                          iconSize: 20,
                                          icon: Icon(Icons.more_vert),
                                          onSelected: (value) {
                                            html.window.open(
                                                'https://rinkeby.etherscan.io/address/$address',
                                                'Rinkeby');
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return {'Open on Etherscan'}
                                                .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: state.contractList[index]
                                                    ['contract_address'],
                                                child: Text(choice),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is ContractListFetchLoading) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: Text("Error"),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
