
import 'package:medical_assistant/src/data/auth_data_manager.dart';
import 'package:medical_assistant/src/network/kint_api.dart';

class Authorization {
  // Проверяем авторизацию. Выкидывает исключение при ошибке подключения.
  static Future<bool> checkAuthorization(AuthDataManager auth) async {
    dynamic result = await KintApi.withAuthData(auth).get("GetDBInfo");
    return (result is Map && result.isNotEmpty);
  }

  // Проверка авторизован ли пользователь. Тут также нужно проверять наличие интернета.
  static Future<bool> isAuthorized() async {
    AuthDataManager auth = await AuthDataManager.getAuthData();
    if (auth.user?.isEmpty ?? false) {
      return false;
    }

    try {
      bool result = await checkAuthorization(auth);
      return result;
    }
    catch (error) {

    }

    return false;
  }
}