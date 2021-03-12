import 'package:flutter/material.dart';

class SnackbarHelper {
  static show({required String msg, required BuildContext context}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }
}
