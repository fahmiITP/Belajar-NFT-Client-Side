import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web3front/Logic/Contracts/ContractSelect/cubit/contract_select_cubit.dart';
import 'package:web3front/Logic/Items/ItemList/bloc/item_list_bloc.dart';
import 'package:web3front/Logic/Items/MintItem/bloc/mint_item_bloc.dart';
import 'package:web3front/Screens/ItemCreation/widgets/item_creation_list.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';

import 'widgets/item_creation_form.dart';

class ItemCreation extends StatefulWidget {
  const ItemCreation({Key? key}) : super(key: key);

  @override
  _ItemCreationState createState() => _ItemCreationState();
}

class _ItemCreationState extends State<ItemCreation> {
  @override
  void initState() {
    super.initState();

    /// Refresh the Screen after build
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (context.read<ContractSelectCubit>().state is ContractSelectSelected) {
        final contractAddress = (context.read<ContractSelectCubit>().state
                as ContractSelectSelected)
            .contractAddress;
        context.read<ItemListBloc>().add(ItemListFetchStart(
            ownerAddress: ethereum.selectedAddress!,
            contractAddress: contractAddress));
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Creation"),
      ),
      body: Stack(
        children: [
          /// Item Creation Widgets
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ResponsiveRowColumn(
                    rowColumn: constraints.maxWidth < 1000 ? false : true,
                    rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    columnSpacing: 20,
                    children: [
                      ResponsiveRowColumnItem(
                        child: ItemCreationForm(),
                      ),
                      ResponsiveRowColumnItem(
                        child: constraints.maxWidth < 1000
                            ? Divider()
                            : VerticalDivider(),
                      ),
                      ResponsiveRowColumnItem(
                        child: ItemCreationList(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          /// Bloc listeners
          BlocListener<MintItemBloc, MintItemState>(
            listener: (context, state) {
              if (state is MintItemLoading) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "${state.progress}/${state.totalProgress} ${state.step}"),
                  duration: Duration(days: 1),
                ));
              } else if (state is MintItemSuccess) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Token Minted Successfully, Token ID : ${state.tokenId}"),
                  duration: Duration(seconds: 5),
                ));

                final contractAddress = (context
                        .read<ContractSelectCubit>()
                        .state as ContractSelectSelected)
                    .contractAddress;
                context.read<ItemListBloc>().add(
                      ItemListFetchStart(
                          ownerAddress: ethereum.selectedAddress!,
                          contractAddress: contractAddress),
                    );
              } else if (state is MintItemFailed) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("${state.error}"),
                  duration: Duration(seconds: 5),
                ));
              }
            },
            child: Container(),
          ),
        ],
      ),
    );
  }
}
