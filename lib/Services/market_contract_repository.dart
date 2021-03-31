import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web3front/Global/Endpoints.dart';
import 'package:web3front/Model/Items/ItemsModel.dart';
import 'package:web3front/Model/MarketContract/MarketDetailModel.dart';

class MarketContractRepository {
  Uri uriParser(uri) {
    return Uri.parse(uri);
  }

  // Get trade market contract human readable abi
  Future<MarketDetailModel> getMarketContractDetails() async {
    try {
      var response =
          await http.post(Uri.parse("${Endpoints.apiBaseUrl}market/"));
      MarketDetailModel result = MarketDetailModel.fromJson(response.body);
      return result;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  /// Put token on sale
  Future<dynamic?> putTokenOnSale({
    required String isOnSale,
    required double price,
    required String msgHash,
    required String signature,
    required String tokenId,
    required String contractAddress,
    required String tokenOwner,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("${Endpoints.apiBaseUrl}market/updateTokenSaleState"),
        body: {
          "isOnSale": isOnSale.toString(),
          "price": price.toString(),
          "msgHash": msgHash,
          "signature": signature,
          "token_id": tokenId.toString(),
          "contract_address": contractAddress,
          "token_owner": tokenOwner
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  /// Get all on-sale token
  Future<ItemListModel> getAllOnSaleToken() async {
    try {
      var response = await http.post(
        Uri.parse("${Endpoints.apiBaseUrl}marketplace/"),
      );

      ItemListModel result =
          ItemListModel.fromJson(jsonDecode(response.body)['rows']);
      return result;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
