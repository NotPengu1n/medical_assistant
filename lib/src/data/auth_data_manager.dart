import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medical_assistant/src/network/synchronization.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Класс для работы с данными авторизации
class AuthDataManager {
  String? publication;
  String? user;
  String? password;

  static String? employeeCache;

  AuthDataManager(){}

  AuthDataManager.withParams(String _publication, String _user, String _password){
    publication = _publication;
    user = _user;
    password = _password;
  }

  // Сохранение данных авторизации
  static Future<void> saveAuthData(String _publication, String _user, String _password) async {
    AuthDataManager.withParams(_publication, _user, _password).save();
  }

  // Сохранение данных авторизации
  Future<void> save() async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'publication', value: publication);
    await storage.write(key: 'user', value: user);
    await storage.write(key: 'password', value: password);
  }

  // Получаем сотрудника по пользователю и сохраняем его
  Future<void> syncEmployee() async {
    String? employee = await Synchronization.getEmployee(user!);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('employee', employee ?? '');
    employeeCache = employee;
  }

  // Получить идентификатор сотрудника из хранилища
  static Future<Map<String, dynamic>> getEmployee() async {
    if (employeeCache != null) {
      return {"id": employeeCache};
    }
    final prefs = await SharedPreferences.getInstance();
    employeeCache = prefs.getString('employee');
    return {"id": employeeCache};
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