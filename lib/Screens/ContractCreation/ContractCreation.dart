import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web3front/Global/CustomTextStyle.dart';
import 'package:web3front/Helpers/SnackbarHelper.dart';
import 'package:web3front/Logic/Contracts/ContractList/bloc/contract_list_bloc.dart';
import 'package:web3front/Logic/Contracts/CreateContract/bloc/contract_create_bloc.dart';
import 'package:web3front/Screens/ContractCreation/widgets/contract_creation_form.dart';
import 'package:web3front/Screens/Widgets/SliderMenuWidget.dart';
import 'package:web3front/Web3_Provider/ethereum.dart';

import 'widgets/contract_creation_list.dart';

class ContractCreation extends StatefulWidget {
  const ContractCreation({Key? key}) : super(key: key);

  @override
  _ContractCreationState createState() => _ContractCreationState();
}

class _ContractCreationState extends State<ContractCreation> {
  @override
  void initState() {
    super.initState();

    /// Refresh the Screen after build
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context
          .read<ContractListBloc>()
          .add(ContractListFetch(userAddress: ethereum.selectedAddress!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future.value(true),
      child: Scaffold(
        body: SliderMenuContainer(
          drawerIconColor: Colors.white,
          appBarColor: Theme.of(context).primaryColor,
          title: Text(
            "Contract Creation",
            style: CustomTextStyle.appBarTitleTextStyle,
          ),
          isTitleCenter: true,
          appBarPadding: EdgeInsets.all(0),
          appBarHeight: 60,
          hasAppBar: true,
          sliderMenu: SliderMenuWidget(),
          sliderMain: BlocListener<ContractCreateBloc, ContractCreateState>(
            listener: (context, state) {
              if (state is ContractCreateLoading) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "${state.progress}/${state.totalProgress} ${state.step}"),
                    duration: Duration(days: 1),
                  ),
                );
              } else if (state is ContractCreateSuccess) {
                SnackbarHelper.show(
                    msg:
                        "Contract has been deployed successfully ${state.contractAddress}",
                    context: context);

                context.read<ContractListBloc>().add(
                    ContractListFetch(userAddress: ethereum.selectedAddress!));
              } else if (state is ContractCreateFailed) {
                SnackbarHelper.show(msg: state.error, context: context);
              }
            },
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
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
                          child: ContractCreationForm(),
                        ),
                        ResponsiveRowColumnItem(
                          child: constraints.maxWidth < 1000
                              ? Divider()
                              : VerticalDivider(),
                        ),
                        ResponsiveRowColumnItem(
                          child: ContractCreationList(),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
