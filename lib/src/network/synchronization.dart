
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';
import 'package:medical_assistant/src/data/auth_data_manager.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_data.dart';
import 'package:medical_assistant/src/features/session_list/assigned_session.dart';
import 'package:medical_assistant/src/network/kint_api.dart';

class Synchronization {
  // Получение списка сеансов по API
  static Future<List<AssignedSession>> getSessions(DateTime date) async {
    List<Map<String, dynamic>> cabinets = CabinetsData.getCabinets(isSelected: true).map((cabinet) => cabinet.toApiMap()).toList();
    String nowTime = date.toApiString();
    Map<String, dynamic> selection = {"НачалоПериода": nowTime, "КонецПериода": nowTime, "Кабинет": cabinets};
    Map<String, dynamic> params =  { "Параметры": selection };

    List<dynamic> result = await KintApi().post("НазначенияИРезультаты", {}, params);
    var list = result.whereType<Map<String, dynamic>>().toList();

    for (var session in list) {
      session["isPassed"] = (session["Пройдено"] as int >= 1);
      session["isNoShow"] = (session["Пройдено"] as int == 0 && session["Осталось"] as int == 0);
      session["id"] = sessionId(session);
      session["ВремяС"] = DateTime.parse(session["ВремяС"]);

      session["Дата"] = session["ДатаСеанса"];
      session["Исполнитель"] = null;
      session["фПлатная"] = session["Платная"];
    }

    return list.map((elem) => AssignedSession.fromMap(elem)).toList();
  }

  static String sessionId(session) {
    return "s" +(session["ДокументНазначения"]["Идентификатор"] ?? "") + session["КодСтроки"].toString();
  }

  // Отметить сеанс по API
  static Future<bool> markSession(Map session, bool isCancel, bool isQRcode) async {
    final sessionCopy = Map.of(session); // Копируем, чтобы не редактировать исходное значение

    sessionCopy["фОтмена"] = isCancel;
    sessionCopy["QRКод"] = isQRcode;
    sessionCopy.remove("ВремяС");
    sessionCopy["ВремяС"] = sessionCopy["ВремяС"] is DateTime ? (sessionCopy["ВремяС"] as DateTime).toApiString() : sessionCopy["ВремяС"];
    sessionCopy["Исполнитель"] = await AuthDataManager.getEmployee();

    bool result = await KintApi().post("ИзменитьСостояниеСеанса", {}, sessionCopy);

    return result;
  }

  // Получить кабинеты по API
  static Future<void> getCabinets() async {
    List<dynamic> result = await KintApi().get("ПроцедурныеКабинеты");
    List<Map<String, dynamic>> list = result.whereType<Map<String, dynamic>>().map((e) => e["Кабинет"] as Map<String, dynamic>).toList();
    CabinetsData.saveFromListMap(list);
  }

  // Отчет "Оказанные услуги"
  static Future<List<Map<String, dynamic>>> getRenderedSessions(DateTime begin, DateTime end) async {
    Map <String, dynamic> params = {"Отчет": "ОказанныеУслуги", "Формат": "JSON"};

    // TODO: сделать другой модуль для работы с отчетами
    final report_params_json = await rootBundle.loadString('assets/rendered_services_parametrs.json');
    Map<String, dynamic> report_params = json.decode(report_params_json);
    report_params["НачалоПериода"] = begin.toApiString();
    report_params["КонецПериода"] = end.toApiString();
    report_params["Отбор"][1]["ЗначениеОтбора"] = await AuthDataManager.getEmployee();
    List<dynamic> result = await KintApi().post("РезультатУФО", params, {"Настройки": report_params});
    var list = result.whereType<Map<String, dynamic>>().toList();
    return list;
  }

  // Получить сотрудника по пользователю
  static Future<Map<String, dynamic>> getEmployee(String username) async {
    // TODO: сделать отдельный метод api для этого
    final dataSourceParamsJson = await rootBundle.loadString('assets/get_employee.json');
    Map<String, dynamic> dataSourceParams = json.decode(dataSourceParamsJson);
    final result = await KintApi().post("ТаблицаИсточникаДанных", {}, {"ИсточникДанных": dataSourceParams, "Наименование": username, "ПреобразоватьСсылки": true});
    final firstItem = result is List && result.isNotEmpty ? result[0] : null;
    final value = firstItem is Map ? firstItem["Значение"] : null;
    return value;
  }
}