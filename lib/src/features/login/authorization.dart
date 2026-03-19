
import 'package:medical_assistant/src/data/auth_data_manager.dart';
import 'package:medical_assistant/src/network/kint_api.dart';

class Authorization {
  static Future<bool> checkAuthorization(AuthDataManager auth) async {
    dynamic result = await KintApi.withAuthData(auth).get("GetDBInfo");
    return true;
  }
}