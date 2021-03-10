import 'package:dio/dio.dart';
import 'package:web3front/Global/Endpoints.dart';

class GetContractAbi {
  final Dio dio = Dio();

  Future<List<String>?> getContractAbi() async {
    try {
      var response = await dio.get("${Endpoints.apiBaseUrl}abi");
      List<String> result = List<String>.from(response.data);
      return result;
    } catch (e) {
      print(e);
    }
  }
}
