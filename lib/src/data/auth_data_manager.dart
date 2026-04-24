import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medical_assistant/src/network/synchronization.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Класс для работы с данными авторизации
class AuthDataManager {
  String? publication;
  String? user;
  String? password;

  static String? _employeeCache;
  static String? _emloyeeNameCache;

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

    // Сохраняем в список пользователей.
    addUserLogin(user ?? "");
  }

  // Удалить данные авторизованного пользователя
  static Future<void> logout() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'user');
    await storage.delete(key: 'password');
  }

  // Получаем сотрудника по пользователю и сохраняем его
  Future<void> syncEmployee() async {
    Map<String, dynamic> employee = await Synchronization.getEmployee(user!);
    final prefs = await SharedPreferences.getInstance();
    String emloyeeId = employee["Идентификатор"] ?? "";
    await prefs.setString('employee', emloyeeId);
    await prefs.setString('employeeName', employee["Наименование"] ?? "");
    _employeeCache = emloyeeId;
  }

  // Получить идентификатор сотрудника из хранилища
  static Future<Map<String, dynamic>> getEmployee() async {
    if (_employeeCache != null) {
      return {"id": _employeeCache};
    }
    final prefs = await SharedPreferences.getInstance();
    _employeeCache = prefs.getString('employee');
    return {"id": _employeeCache};
  }

  // Получить имя текущего сотрудника
  static Future<String> getEmployeeName() async {
    if (_emloyeeNameCache != null) {
      return _emloyeeNameCache ?? "";
    }
    final prefs = await SharedPreferences.getInstance();
    _emloyeeNameCache = prefs.getString('employeeName');
    return _emloyeeNameCache ?? "";
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

  // Добавляем список пользователей, под которыми происходила авторизация в МП.
  Future<void> addUserLogin(String login) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> users = prefs.getStringList('user_logins') ?? [];

    if (!users.contains(login)) {
      users.add(login);
      await prefs.setStringList('user_logins', users);
    }
  }

  // Получаем список пользователей, под которыми происходила авторизация в МП.
  static Future<List<String>> getUserLogins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('user_logins') ?? [];
  }
}