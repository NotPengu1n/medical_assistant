
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_data.dart';
import 'package:medical_assistant/src/network/kint_api.dart';

class Synchronization {
  // Получение списка сеансов по API
  static Future<List<Map<String, dynamic>>> getSessions(DateTime date) async {
    List<Map<String, dynamic>> cabinets = CabinetsData.getCabinets(isSelected: true).map((cabinet) => cabinet.toApiMap()).toList();
    String nowTime = date.toApiString();
    Map<String, dynamic> selection = {"НачалоПериода": nowTime, "КонецПериода": nowTime, "Кабинет": cabinets};
    Map<String, dynamic> params =  { "Параметры": selection };

    List<dynamic> result = await KintApi().post("НазначенияИРезультаты", {}, params);
    var list = result.whereType<Map<String, dynamic>>().toList();
    return list;
  }

  // Мой левак
  Future<List<Map<String, dynamic>>> getMedicines() async {
    Map<String, dynamic> selection = {"НачалоПериода": "2026-02-12T00:00:00", "КонецПериода": "2026-02-28T00:00:00"};
    List<dynamic> result = await KintApi().post("Медикаменты", {}, selection);
    var list = result.whereType<Map<String, dynamic>>().toList();
    return list;
  }

  // Отметить сеанс по API
  static Future<bool> markSession(Map session, bool isCancel, bool isQRcode) async {
    session["фОтмена"] = isCancel;
    session["QRКод"] = isQRcode;

    bool result = await KintApi().post("ИзменитьСостояниеСеанса", {}, session);

    return result;
  }

  // Получить кабинеты по API
  static Future<void> getCabinets() async {
    List<dynamic> result = await KintApi().get("ПроцедурныеКабинеты");
    List<Map<String, dynamic>> list = result.whereType<Map<String, dynamic>>().map((e) => e["Кабинет"] as Map<String, dynamic>).toList();
    CabinetsData.saveFromListMap(list);
  }
}