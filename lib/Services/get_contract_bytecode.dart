import 'package:dio/dio.dart';

class GetContractByteCode {
  final Dio dio = Dio();

  static const apiBaseUrl = 'http://localhost:3000/';

  Future<String?> getBytecode() async {
    try {
      var response = await dio.get("${apiBaseUrl}bytecode");
      print(response);
      return response.data ?? Future.value("Failed to Get Data");
    } catch (e) {
      print(e);
    }
  }
}
