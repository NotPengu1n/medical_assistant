import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Класс для работы с данными авторизации
class AuthDataManager {
  String? publication;
  String? user;
  String? password;

  AuthDataManager(){}

  AuthDataManager.withParams(String _publication, String _user, String _password){
    publication = _publication;
    user = _user;
    password = _password;
  }

  // Сохранение данных авторизации
  static Future<void> saveAuthData(String _publication, String _user, String _password) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'publication', value: _publication);
    await storage.write(key: 'user', value: _user);
    await storage.write(key: 'password', value: _password);
  }

  // Получение данных авторизации
  static Future<AuthDataManager> getAuthData() async {
    AuthDataManager auth = AuthDataManager();
    final storage = FlutterSecureStorage();

    auth.publication = await storage.read(key: 'publication');
    auth.user = await storage.read(key: 'user');
    auth.password = await storage.read(key: 'password');

    return auth;
  }
}