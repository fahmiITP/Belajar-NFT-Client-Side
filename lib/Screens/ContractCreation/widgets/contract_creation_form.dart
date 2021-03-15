import 'package:flutter/material.dart';
import 'package:web3front/Logic/Contracts/ContractForm/bloc/contract_form_bloc.dart';
import 'package:web3front/Logic/Contracts/CreateContract/bloc/contract_create_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractCreationForm extends StatelessWidget {
  const ContractCreationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        width: 400,
        height: 500,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
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
                    "Welcome, create your contract here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Contract Name Textfield
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Contract Name",
                          hintText:
                              "Enter your desired contract symbol, Eg : Photopack",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          context.read<ContractFormBloc>().add(
                                ContractFormChanged(
                                  contractName: text,
                                  contractSymbol: (context
                                          .read<ContractFormBloc>()
                                          .state as ContractFormInitial)
                                      .contractSymbol,
                                ),
                              );
                        },
                      ),

                      /// Padding
                      SizedBox(height: 12),

                      /// Contract Symbol Textfield
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Contract Symbol",
                          hintText:
                              "Enter your desired contract symbol, Eg : PPG",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          context.read<ContractFormBloc>().add(
                                ContractFormChanged(
                                  contractName: (context
                                          .read<ContractFormBloc>()
                                          .state as ContractFormInitial)
                                      .contractName,
                                  contractSymbol: text,
                                ),
                              );
                        },
                      ),

                      SizedBox(height: 20),

                      /// Contract Create Button
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<ContractCreateBloc>().add(
                                ContractCreateStart(
                                    contractName: (context
                                            .read<ContractFormBloc>()
                                            .state as ContractFormInitial)
                                        .contractName,
                                    contractSymbol: (context
                                            .read<ContractFormBloc>()
                                            .state as ContractFormInitial)
                                        .contractSymbol));
                          },
                          child: Center(
                            child: Text("Create Contract"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
