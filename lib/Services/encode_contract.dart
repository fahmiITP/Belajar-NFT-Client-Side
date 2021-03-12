import 'package:dio/dio.dart';
import 'package:web3front/Global/Endpoints.dart';

class EncodeContract {
  final Dio dio = Dio();

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
}
