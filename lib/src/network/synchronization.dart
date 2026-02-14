
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:medical_assistant/src/network/kint_api.dart';

class Synchronization {
  Future<List<Map<String, dynamic>>> getSessions() async {
    Map<String, dynamic> selection = {"НачалоПериода": "2026-02-12T00:00:00", "КонецПериода": "2026-02-28T00:00:00"};
    Map<String, dynamic> params =  { "Параметры": jsonEncode(selection) };
    List<dynamic> a = await KintApi().post("НазначенияИРезультаты", params);
    var list = a.whereType<Map<String, dynamic>>().toList();
    return list;
  }
}