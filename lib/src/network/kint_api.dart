import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:medical_assistant/src/data/auth_data_manager.dart';
import 'package:medical_assistant/src/network/kint_api_exception.dart';

// Работа с http-сервисом KintApi
class KintApi {
  late String username;
  late String password;
  late String auth;
  late String server;

  String service = "/hs/KintAPI.hs/GetData";

  late Dio connection;
  bool connectionCreated = false;

  // Установка параметров соединения с авторизацией из настроек. Установка происходит при вызове метода API.
  KintApi(){

  }

  // Установка параметров соединение по параметру
  KintApi.withAuthData(AuthDataManager auth){
    createConnectionWithAuth(auth);
  }

  // Заполнение данных авторизации и создание соединения
  void createConnectionWithAuth(AuthDataManager auth){
    username = auth.user!;
    password = auth.password!;
    server = auth.publication!;
    setAuth();
    createConnection();
  }

  // Установка переменной для заголовка авторизации запроса
  void setAuth() {
    auth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  }

  // Создание соединения с сервером
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

    connectionCreated = true;
  }

  // Отправка запроса в сервис.
  dynamic send(String method, [Map<String, dynamic> params = const {}, bool post = false, dynamic data]) async {
    if (!connectionCreated) {
      createConnectionWithAuth(await AuthDataManager.getAuthData());
    }

    Map<String, dynamic> result = {};
    Map<String, dynamic> allParams = (<String, dynamic>{"Method": method})..addAll(params);

    try {
      dynamic response;
      if (post) {
        response = await connection.post(service, queryParameters: allParams, data: data);
      } else {
        response = await connection.get(service, queryParameters: allParams);
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

    if (result['Result'] is String) {
      return jsonDecode(result['Result']);
    }

    return result['Result'];
  }

  // Отправить GET-запрос.
  dynamic get(String method, [Map<String, dynamic> params = const {}]) async {
    return await send(method, params);
  }

  // Отправить POST-запрос.
  dynamic post(String method, [Map<String, dynamic> params = const {}, dynamic data]) async {
    return await send(method, params, true, data);
  }
}