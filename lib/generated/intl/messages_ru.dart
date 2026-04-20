// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(error) => "Не удалось подключиться: ${error}";

  static String m1(error) => "Ошибка обработки QR-кода: ${error}";

  static String m2(userName) => "QR-код считан. Пользователь: ${userName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName":
            MessageLookupByLibrary.simpleMessage("Отметка услуг (Медсестра)"),
        "authorization_success":
            MessageLookupByLibrary.simpleMessage("Успешная авторизация"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "choose": MessageLookupByLibrary.simpleMessage("Выбрать"),
        "choose_all": MessageLookupByLibrary.simpleMessage("Выбрать все"),
        "choose_cabinets":
            MessageLookupByLibrary.simpleMessage("Выбрать рабочие кабинеты"),
        "connection_failed": m0,
        "emptyMedicines":
            MessageLookupByLibrary.simpleMessage("Нет назначений медикаментов"),
        "emptySessions": MessageLookupByLibrary.simpleMessage("Нет сеансов"),
        "error": MessageLookupByLibrary.simpleMessage("Ошибка"),
        "fill_all_fields":
            MessageLookupByLibrary.simpleMessage("Заполните все поля"),
        "indicate_cabinets":
            MessageLookupByLibrary.simpleMessage("Укажите рабочие кабинеты"),
        "log_in": MessageLookupByLibrary.simpleMessage("Войти"),
        "login_screen_title":
            MessageLookupByLibrary.simpleMessage("Вход в систему"),
        "manual_input_title":
            MessageLookupByLibrary.simpleMessage("ИЛИ ВВЕДИТЕ ДАННЫЕ ВРУЧНУЮ"),
        "mark": MessageLookupByLibrary.simpleMessage("Оказано"),
        "medicines": MessageLookupByLibrary.simpleMessage("Медикаменты"),
        "no_cabinets":
            MessageLookupByLibrary.simpleMessage("Нет доступных кабинетов"),
        "noshow": MessageLookupByLibrary.simpleMessage("Неявка"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "period": MessageLookupByLibrary.simpleMessage("Период"),
        "publication": MessageLookupByLibrary.simpleMessage("Публикация"),
        "qr_code_processing_error": m1,
        "qr_code_scanned_user": m2,
        "qrcode": MessageLookupByLibrary.simpleMessage("QR-код"),
        "quick_login_qr":
            MessageLookupByLibrary.simpleMessage("Быстрый вход по QR-коду"),
        "remove_all": MessageLookupByLibrary.simpleMessage("Снять все"),
        "rendered_sessions":
            MessageLookupByLibrary.simpleMessage("Оказанные услуги"),
        "scan_qrcode":
            MessageLookupByLibrary.simpleMessage("Сканировать QR-код"),
        "sessions": MessageLookupByLibrary.simpleMessage("Сеансы"),
        "username": MessageLookupByLibrary.simpleMessage("Пользователь")
      };
}
