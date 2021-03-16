import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3front/Logic/Items/ItemForm/bloc/item_form_bloc.dart';
import 'package:web3front/Logic/Items/MintItem/bloc/mint_item_bloc.dart';

class ItemCreationForm extends StatefulWidget {
  const ItemCreationForm({Key? key}) : super(key: key);

  @override
  _ItemCreationFormState createState() => _ItemCreationFormState();
}

class _ItemCreationFormState extends State<ItemCreationForm> {
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
                    "Create your item here",
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
                      /// Item Image
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            allowMultiple: false,
                          );

                          if (result != null) {
                            final image =
                                base64Encode(result.files.single.bytes!);

                            context.read<ItemFormBloc>().add(
                                  ItemFormChanged(
                                    imageBytes: image,
                                    itemName: (context
                                            .read<ItemFormBloc>()
                                            .state as ItemFormInitial)
                                        .itemName,
                                    itemDescription: (context
                                            .read<ItemFormBloc>()
                                            .state as ItemFormInitial)
                                        .itemDescription,
                                  ),
                                );
                          }
                        },
                        child: context.select((ItemFormBloc b) =>
                                    (b.state as ItemFormInitial).imageBytes) ==
                                ""
                            ? Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey.shade300,
                                  ),
                                  color: Colors.grey.shade300,
                                ),
                                child: Center(
                                  child: Icon(Icons.add_a_photo),
                                ),
                              )
                            : Container(
                                height: 150,
                                child: Center(
                                  child: Image.memory(
                                    base64Decode(
                                      context.select((ItemFormBloc b) =>
                                          (b.state as ItemFormInitial)
                                              .imageBytes),
                                    ),
                                  ),
                                ),
                              ),
                      ),

                      /// Padding
                      SizedBox(height: 12),

                      /// Item Name Textfield
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Item Name",
                          hintText: "Enter your desired item name",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          context.read<ItemFormBloc>().add(
                                ItemFormChanged(
                                  imageBytes: (context
                                          .read<ItemFormBloc>()
                                          .state as ItemFormInitial)
                                      .imageBytes,
                                  itemName: text,
                                  itemDescription: (context
                                          .read<ItemFormBloc>()
                                          .state as ItemFormInitial)
                                      .itemDescription,
                                ),
                              );
                        },
                      ),

                      /// Padding
                      SizedBox(height: 12),

                      /// Item Description Textfield
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Item Description",
                          hintText: "Enter your desired Item Description",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          context.read<ItemFormBloc>().add(
                                ItemFormChanged(
                                  imageBytes: (context
                                          .read<ItemFormBloc>()
                                          .state as ItemFormInitial)
                                      .imageBytes,
                                  itemName: (context.read<ItemFormBloc>().state
                                          as ItemFormInitial)
                                      .itemName,
                                  itemDescription: text,
                                ),
                              );
                        },
                      ),

                      SizedBox(height: 20),

                      /// Item Create Button
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            final imageBytes = (context
                                    .read<ItemFormBloc>()
                                    .state as ItemFormInitial)
                                .imageBytes;
                            final itemName = (context.read<ItemFormBloc>().state
                                    as ItemFormInitial)
                                .itemName;
                            final itemDescription = (context
                                    .read<ItemFormBloc>()
                                    .state as ItemFormInitial)
                                .itemDescription;
                            if (imageBytes != "" &&
                                itemName != "" &&
                                itemDescription != "") {
                              context.read<MintItemBloc>().add(MintItemStart(
                                  imageBytes: imageBytes,
                                  itemName: itemName,
                                  itemDescription: itemDescription));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Please fill in the empty fields, as well as the image."),
                              ));
                            }
                          },
                          child: Center(
                            child: Text("Add item to Contract"),
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
