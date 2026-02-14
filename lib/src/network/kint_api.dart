import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:medical_assistant/src/network/kint_api_exception.dart';

class KintApi {
  late String username;
  late String password;
  late String auth;
  late String server;

  String service = "/kus/hs/KintAPI.hs/GetData";

  late Dio connection;

  KintApi(){
    username = 'Дударев Григорий';
    password = '';
    auth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    server = "http://192.168.31.125";
    //server = "http://10.236.3.110";
    createConnection();
  }

  void createConnection(){
    connection = Dio(BaseOptions(
        baseUrl: server,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 60),
        followRedirects: true,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': auth
        }
    ));
  }

  dynamic send(String method, [Map<String, dynamic> params = const {}, bool post = false, dynamic data]) async {
    Map<String, dynamic> result = {};
    params["Method"] = method;

    try {
      dynamic response;
      if (post) {
        response = await connection.post(service, queryParameters: params, data: data);
      } else {
        response = await connection.get(service, queryParameters: params);
      }

      if (response.statusCode == 200) {
        result = response.data;
      }
      else {
        throw KintApiException(code: response.statusCode ?? 0);
      }

      if (result["Success"] == false) {
        throw KintApiException(
            code: (result['Result'] as Map<String, dynamic>?)?['КодОшибки'],
            error: (result['Result'] as Map<String, dynamic>?)?['Error']
        );
      }

    } on DioException catch (error) {
      throw KintApiException(code: 0, error: error.toString());
    } catch (error) {
      throw KintApiException(code: 0, error: error.toString());
    }

    return jsonDecode(result['Result']);
  }

  dynamic get(String method, [Map<String, dynamic> params = const {}]) async {
    return await send(method, params);
  }

  dynamic post(String method, [Map<String, dynamic> params = const {}, dynamic data]) async {
    return await send(method, params, true, data);
  }
}