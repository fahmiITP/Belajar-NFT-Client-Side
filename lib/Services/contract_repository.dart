import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web3front/Global/Endpoints.dart';

class ContractRepository {
  final Dio dio = Dio();

  /// Get encoded contract abi
  Future<String?> getEncodedAbi({
    required String contractName,
    required String contractSymbol,
  }) async {
    try {
      var response = await dio.get(
          "${Endpoints.apiBaseUrl}encode?contractName=$contractName&contractSymbol=$contractSymbol");
      return response.data ?? Future.value("Failed to Get Data");
    } catch (e) {
      print(e);
    }
  }

  /// Get human readable contract abi
  Future<List<String>?> getContractAbi() async {
    try {
      var response = await dio.get("${Endpoints.apiBaseUrl}abi");
      List<String> result = List<String>.from(response.data);
      return result;
    } catch (e) {
      print(e);
    }
  }

  /// Save contract data to DB
  Future<dynamic?> saveContract({
    required String contractAddress,
    required String contractAbi,
    required String contractOwner,
  }) async {
    try {
      var response =
          await dio.post("${Endpoints.apiBaseUrl}contracts/add", data: {
        "contract_address": contractAddress,
        "contract_abi": contractAbi,
        "contract_owner": contractOwner
      });
      return response.data ?? Future.value("Failed to Save Data");
    } catch (e) {
      print(e);
    }
  }

  /// Get Contract List
  Future<List<dynamic>?> getContracts({required String userAddress}) async {
    try {
      var response = await dio
          .post("${Endpoints.apiBaseUrl}contracts/userContracts", data: {
        "owner_address": userAddress,
      });
      List<dynamic> result = List<dynamic>.from(response.data['rows']);
      return result;
    } catch (e) {
      print(e);
    }
  }
}
