import 'dart:math';

import 'package:web3front/Model/Signers/SignMsgHash.dart';
import 'package:web3front/Web3_Provider/ethers.dart';

class EtherHelpers {
  /// Ethers to Wei Converter
  static etherToWei({required double ethers}) {
    num convertedEther = ethers * pow(10, 18);
    return convertedEther;
  }

  /// Ethers to Wei Converter
  static weiToGwei({required double wei}) {
    num convertedEther = wei * pow(10, -9);
    return convertedEther;
  }

  /// Ethers to Wei Converter
  static weiToEthers({required double wei}) {
    num convertedEther = wei * pow(10, -18);
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

  /// Sign Sell Token Approval
  ///
  /// [sellerAddress] The token owner.
  /// [originalContractAddress] The Contract address that mints the token.
  /// [tradeMarketAddress] The trade market address built by system. This address will holds all the market transaction.
  /// [price] The sell price that owner wants.
  /// [tokenId] The token id that the owner want to sell.
  static SignMsgHash signTokenSell(
      {required String sellerAddress,
      required String originalContractAddress,
      required String tradeMarketAddress,
      required String price,
      required String tokenId}) {
    /// Raw Msg Hash
    final msgHash = Utils.keccak256(
      DefaultABICoder.encode(
        ['address', 'address', 'address', 'uint256', 'uint256'],
        [
          sellerAddress,
          originalContractAddress,
          tradeMarketAddress,
          price,
          tokenId
        ],
      ),
    );

    /// Added Prefix
    final arrayify = Utils.arrayify(msgHash);
    return SignMsgHash(arrayifyHash: arrayify, msgHash: msgHash);
  }
}
