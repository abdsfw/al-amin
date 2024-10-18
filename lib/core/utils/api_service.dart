import 'package:dio/dio.dart';

import '../../constants.dart';
import '../cache/cashe_helper.dart';

class ApiService {
  final _baseUrl = Constants.kDomain;
  final Dio dio;

  ApiService(this.dio);

  Future<Map<String, dynamic>> get({
    required String endPoint,
  }) async {
    String token = await CasheHelper.getData(key: Constants.kToken);

    dio.options.headers["Authorization"] = "Bearer $token";

    var response = await dio.get(
      '$_baseUrl$endPoint',
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getWithBody({
    required String endPoint,
    CancelToken? cancelToken,
    required var data,
  }) async {
    String token = await CasheHelper.getData(key: Constants.kToken);

    dio.options.headers["Authorization"] = "Bearer $token";
    // dio.options.headers['Content-Type'] = "application/json";

    var response = await dio.get('$_baseUrl$endPoint', data: data);

    //
    return response.data;
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    required var data,
    bool isLogin = false,
  }) async {
    String token =
        (isLogin) ? '' : await CasheHelper.getData(key: Constants.kToken);

    (isLogin) ? null : dio.options.headers["Authorization"] = "Bearer $token";
    // dio.options.headers['Content-Type'] = "application/json";

    var response = await dio.post('$_baseUrl$endPoint', data: data);

    // print(
    //     ' ${response.data} ----------------------------------------\n ---------------------------------------');
    return response.data;
  }

  Future<Map<String, dynamic>> put({
    required String endPoint,
    required var data,
  }) async {
    String token = await CasheHelper.getData(key: Constants.kToken);

    dio.options.headers["Authorization"] = "Bearer $token";
    // dio.options.headers['Content-Type'] = "application/json";

    var response = await dio.put('$_baseUrl$endPoint', data: data);
    //
    // print(
    // '  heeeeeeeeeer resopopsdklfskdlvdl ${response.data} ----------------------------------------\n ---------------------------------------');
    return response.data;
  }

  Future<Map<String, dynamic>> delete(
      {required String endPoint, required int id}) async {
    String token = await CasheHelper.getData(key: Constants.kToken);
    dio.options.headers["Authorization"] = "Bearer $token";
    // headers: {
    //       'Content-Type': 'application/json',
    //     },
    // dio.options.headers['Content-Type'] = "application/json";
    var response = await dio.delete('$_baseUrl$endPoint$id');
    return response.data;
  }

  Future<Map<String, dynamic>> deleteMany(
      {required String endPoint, required var data}) async {
    String token = await CasheHelper.getData(key: Constants.kToken);
    dio.options.headers["Authorization"] = "Bearer $token";
    // dio.options.headers['Content-Type'] = "application/json";

    var response = await dio.delete('$_baseUrl$endPoint', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> getHeader({required String url}) async {
    // String token = await CasheHelper.getData(key: Constants.kToken);
    // dio.options.headers["Authorization"] = "Bearer $token";
    // dio.options.headers['Content-Type'] = "application/json";

    var response = await dio.head(url);
    return response.headers.map;
  }
}
