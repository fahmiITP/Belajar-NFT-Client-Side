import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web3front/Global/Endpoints.dart';

class ContractRepository {
  Uri uriParser(uri) {
    return Uri.parse(uri);
  }

  /// Get encoded contract abi
  Future<String?> getEncodedAbi({
    required String contractName,
    required String contractSymbol,
  }) async {
    try {
      var response = await http.get(uriParser(
          "${Endpoints.apiBaseUrl}encode?contractName=$contractName&contractSymbol=$contractSymbol"));
      return response.body;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  /// Get human readable contract abi
  Future<List<String>?> getContractAbi() async {
    try {
      var response = await http.get(uriParser("${Endpoints.apiBaseUrl}abi"));
      List<String> result = List<String>.from(jsonDecode(response.body));
      return result;
    } catch (e) {
      print(e);
      return [e.toString()];
    }
  }

  /// Save contract data to DB
  Future<dynamic?> saveContract({
    required String contractAddress,
    required String contractAbi,
    required String contractOwner,
  }) async {
    try {
      var response = await http
          .post(uriParser("${Endpoints.apiBaseUrl}contracts/add"), body: {
        "contract_address": contractAddress,
        "contract_abi": contractAbi,
        "contract_owner": contractOwner
      });
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  /// Get Contract List
  Future<List<dynamic>?> getContracts({required String userAddress}) async {
    try {
      var response = await http.post(
          uriParser("${Endpoints.apiBaseUrl}contracts/getAllContract"),
          body: {
            "owner_address": userAddress,
          });
      List<dynamic> result =
          List<dynamic>.from(jsonDecode(response.body)['rows']);
      return result;
    } catch (e) {
      print(e);
      return [e.toString()];
    }
  }
}
