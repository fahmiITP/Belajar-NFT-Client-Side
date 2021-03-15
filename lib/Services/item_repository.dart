import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:web3front/Global/Endpoints.dart';

class ItemRepository {
  final Dio dio = Dio();

  /// Get contract token
  Future<List<dynamic>?> getContractTokens({
    required String contractAddress,
    required String ownerAddress,
  }) async {
    try {
      var response = await dio.post(
        "${Endpoints.apiBaseUrl}tokens",
        data: {
          "contract_address": contractAddress,
          "owner_address": ownerAddress
        },
      );

      List<dynamic> result = List<dynamic>.from(response.data['rows']);
      return result;
    } catch (e) {
      print(e);
    }
  }

  /// Save token metadata
  Future<dynamic?> saveTokenMetadata({
    required String contractAddress,
    required String ownerAddress,
    required String imageBytes,
    required String itemName,
    required String itemDescription,
    required int tokenId,
  }) async {
    try {
      var response = await dio.post(
        "${Endpoints.apiBaseUrl}tokens/add",
        data: {
          "contract_address": contractAddress,
          "owner_address": ownerAddress,
          "token_id": tokenId,
          "name": itemName,
          "description": itemDescription,
          "image": imageBytes
        },
        onSendProgress: (count, total) {
          print("$count / $total");
        },
      );

      print(response.data);

      return response.data ?? Future.value("Error Saving Metadata");
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  /// Burn token metadata
  Future<dynamic?> burnToken({
    required String contractAddress,
    required int tokenId,
  }) async {
    try {
      var response = await dio.post(
        "${Endpoints.apiBaseUrl}tokens/burn",
        data: {
          "contract_address": contractAddress,
          "token_id": tokenId,
        },
        onSendProgress: (count, total) {
          print("$count / $total");
        },
      );

      print(response.data);

      return response.data ?? Future.value("Error Saving Metadata");
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  /// Burn token metadata
  Future<dynamic?> transferToken(
      {required String contractAddress,
      required int tokenId,
      required String newOwner}) async {
    try {
      var response = await dio.post(
        "${Endpoints.apiBaseUrl}tokens/transfer",
        data: {
          "contract_address": contractAddress,
          "token_id": tokenId,
          "new_owner": newOwner
        },
        onSendProgress: (count, total) {
          print("$count / $total");
        },
      );

      print(response.data);

      return response.data ?? Future.value("Error Saving Metadata");
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
      var response = await dio.get(
          "${Endpoints.apiBaseUrl}tokens/metadata/$contractAddress/$tokenId");
      return response.data ?? Future.value("Failed to Get Data");
    } catch (e) {
      print(e);
    }
  }
}
