import 'package:dio/dio.dart';
import 'package:web3front/Global/Endpoints.dart';

class SaveContractRepository {
  final Dio dio = Dio();

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
}
