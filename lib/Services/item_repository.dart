import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web3front/Global/Endpoints.dart';

class ItemRepository {
  /// Get contract token
  Future<List<dynamic>?> getContractTokens({
    required String contractAddress,
    required String ownerAddress,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("${Endpoints.apiBaseUrl}tokens"),
        body: {
          "contract_address": contractAddress,
          "owner_address": ownerAddress
        },
      );

      List<dynamic> result =
          List<dynamic>.from(jsonDecode(response.body)['rows']);
      return result;
    } catch (e) {
      print(e);
      return [e.toString()];
    }
  }

  /// Save token metadata
  Future<dynamic?> saveTokenMetadata(
      {required String contractAddress,
      required String ownerAddress,
      required String imageBytes,
      required String itemName,
      required String itemDescription,
      required String tokenId,
      Function(int, int)? onSendProgressCallback}) async {
    try {
      var response = await http.post(
        Uri.parse("${Endpoints.apiBaseUrl}tokens/add"),
        body: {
          "contract_address": contractAddress,
          "owner_address": ownerAddress,
          "token_id": tokenId,
          "name": itemName,
          "description": itemDescription,
          "image": imageBytes
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  /// Burn token metadata
  Future<dynamic?> burnToken({
    required String contractAddress,
    required String tokenId,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("${Endpoints.apiBaseUrl}tokens/burn"),
        body: {
          "contract_address": contractAddress,
          "token_id": tokenId,
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  /// Burn token metadata
  Future<dynamic?> transferToken(
      {required String contractAddress,
      required String tokenId,
      required String newOwner}) async {
    try {
      var response = await http.post(
        Uri.parse("${Endpoints.apiBaseUrl}tokens/transfer"),
        body: {
          "contract_address": contractAddress,
          "token_id": tokenId,
          "new_owner": newOwner
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  /// Get Token Metadata
  Future<dynamic?> getTokenMetadata({
    required String contractAddress,
    required String tokenId,
  }) async {
    try {
      var response = await http.get(Uri.parse(
          "${Endpoints.apiBaseUrl}tokens/metadata/$contractAddress/$tokenId"));
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
