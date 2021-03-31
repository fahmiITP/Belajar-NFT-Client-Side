import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web3front/Global/Endpoints.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ItemRepository {
  /// Initialize Firebase Storage Instance
  FirebaseStorage storage = FirebaseStorage.instance;

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

  /// Upload token image
  Future<String?> uploadImageToStorage(
      {required String encodedImage,
      required String fileName,
      required String contractAddress}) async {
    // Create your custom metadata.
    SettableMetadata metadata = SettableMetadata(
      customMetadata: <String, String>{
        "contentType": "image/jpeg",
      },
    );
    try {
      final res = await storage
          .ref('nft-image-upload/$contractAddress/$fileName.jpeg')
          .putString(encodedImage,
              format: PutStringFormat.base64, metadata: metadata);

      return res.ref.getDownloadURL();
    } catch (e) {
      print(e);
      throw e;
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

  /// Transfer token metadata
  Future<dynamic?> transferToken(
      {required String contractAddress,
      required String tokenId,
      required String newOwner}) async {
    print(newOwner);
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

  /// Get All User Tokens
  Future<List<dynamic>?> getAllUserTokens({
    required String ownerAddress,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("${Endpoints.apiBaseUrl}tokens/getAllUserTokens"),
        body: {"owner_address": ownerAddress},
      );

      List<dynamic> result =
          List<dynamic>.from(jsonDecode(response.body)['rows']);
      return result;
    } catch (e) {
      print(e);
      return [e.toString()];
    }
  }
}
