import 'dart:math';

class EtherHelpers {
  /// Ethers to Wei Converter
  static etherToWei({required double ethers}) {
    num convertedEther = ethers * pow(10, 18);
    return convertedEther;
  }

  /// Ether Digit Regex Validator
  static etherDigitValidator({required String value}) {
    RegExp regex = new RegExp(r'^(?=\D*(?:\d\D*){1,20}$)\d+(?:\.\d{1,18})?$');
    if (!regex.hasMatch(value))
      return 'Enter Valid Number';
    else
      return null;
  }
}
