@JS()
library stringify;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js/js.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:web3front/Logic/Contracts/ContractForm/bloc/contract_form_bloc.dart';
import 'package:web3front/Logic/Contracts/ContractList/bloc/contract_list_bloc.dart';
import 'package:web3front/Logic/Contracts/ContractSelect/cubit/contract_select_cubit.dart';
import 'package:web3front/Logic/Contracts/CreateContract/bloc/contract_create_bloc.dart';
import 'package:web3front/Logic/Items/BurnItem/bloc/burn_item_bloc.dart';
import 'package:web3front/Logic/Items/ItemForm/bloc/item_form_bloc.dart';
import 'package:web3front/Logic/Items/MintItem/bloc/mint_item_bloc.dart';
import 'package:web3front/Logic/Items/MyItems/bloc/my_items_bloc.dart';
import 'package:web3front/Logic/Items/SaleItem/bloc/sale_item_bloc.dart';
import 'package:web3front/Logic/Items/SelectItem/cubit/select_item_cubit.dart';
import 'package:web3front/Logic/Metamask/Check_Metamask/bloc/metamask_check_bloc.dart';
import 'package:web3front/Logic/Metamask/Connect_Metamask/bloc/metamask_connect_bloc.dart';
import 'package:web3front/Routes/GeneratedRoutes.dart';
import 'package:web3front/Routes/RouteName.dart';
import 'package:web3front/Services/market_contract_repository.dart';

import 'Logic/Items/ItemList/bloc/item_list_bloc.dart';
import 'Logic/Items/TransferItem/bloc/transfer_item_bloc.dart';

Future<void> main() async {
  /// Call this function to make sure the app is initialized. Otherwise, we can't access native code
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase Core
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MarketContractRepository marketContractRepository =
      MarketContractRepository();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MetamaskCheckBloc()),
        BlocProvider(create: (context) => MetamaskConnectBloc()),
        BlocProvider(create: (context) => ContractFormBloc()),
        BlocProvider(create: (context) => ContractCreateBloc()),
        BlocProvider(create: (context) => ContractListBloc()),
        BlocProvider(create: (context) => ContractSelectCubit()),
        BlocProvider(create: (context) => ItemFormBloc()),
        BlocProvider(create: (context) => ItemListBloc()),
        BlocProvider(create: (context) => MyItemsBloc()),
        BlocProvider(create: (context) => SelectItemCubit()),
        BlocProvider(
          create: (context) => MintItemBloc(
            contractListBloc: context.read<ContractListBloc>(),
            contractSelectCubit: context.read<ContractSelectCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => BurnItemBloc(
            context.read<ContractListBloc>(),
            context.read<ContractSelectCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => TransferItemBloc(
            context.read<ContractListBloc>(),
            context.read<ContractSelectCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => SaleItemBloc(
            contractListBloc: context.read<ContractListBloc>(),
            contractSelectCubit: context.read<ContractSelectCubit>(),
            marketContractRepository: marketContractRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Demo NFT',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: Routes.generateRoute,
        builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          minWidth: 400,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.autoScale(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.autoScale(1366, name: DESKTOP),
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
