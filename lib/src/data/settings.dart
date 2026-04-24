
import 'package:medical_assistant/src/data/auth_data_manager.dart';
import 'package:medical_assistant/src/network/kint_api.dart';

class Settings {
  // Настройка отметки только по qr-коду
  static bool qrCodeOnly = false;

  // Синхронизация настроек
  static Future<void> syncSettings() async {
    Map<String, dynamic> params = {"КодПриложения": "КинтМедсестра", "Сотрудник": (await AuthDataManager.getEmployee())["id"]};
    Map<String, dynamic> settingsMap = await KintApi().get("НастройкиМобильногоПриложения", params);
    qrCodeOnly = settingsMap["ОтметкаУслугТолькоПоQRКоду"] ?? false;
  }
}