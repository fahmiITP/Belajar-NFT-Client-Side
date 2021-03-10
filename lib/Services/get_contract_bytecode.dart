import 'package:dio/dio.dart';
import 'package:web3front/Global/Endpoints.dart';

class GetContractByteCode {
  final Dio dio = Dio();

  Future<String?> getBytecode() async {
    try {
      var response = await dio.get("${Endpoints.apiBaseUrl}bytecode");
      return response.data ?? Future.value("Failed to Get Data");
    } catch (e) {
      print(e);
    }
  }
}
