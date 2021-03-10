import 'package:dio/dio.dart';

class EncodeContract {
  final Dio dio = Dio();

  static const apiBaseUrl = 'http://localhost:3000/';

  Future<String?> getEncodedAbi({
    required String contractName,
    required String contractSymbol,
  }) async {
    try {
      var response = await dio
          .get("${apiBaseUrl}encode?contractName=Test&contractSymbol=TST");
      print(response);
      return response.data ?? Future.value("Failed to Get Data");
    } catch (e) {
      print(e);
    }
  }
}
