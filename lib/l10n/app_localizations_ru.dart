// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get sessions => 'Сеансы';

  @override
  String get medicines => 'Медикаменты';

  @override
  String get mark => 'Оказано';

  @override
  String get noshow => 'Неявка';

  @override
  String get cancel => 'Отмена';

  @override
  String get qrcode => 'QR-код';

  @override
  String get scan_qrcode => 'Сканировать QR-код';

  @override
  String get publication => 'Публикация';

  @override
  String get username => 'Пользователь';

  @override
  String get password => 'Пароль';

  @override
  String get log_in => 'Войти';

  @override
  String get quick_login_qr => 'Быстрый вход по QR-коду';

  @override
  String qr_code_scanned_user(Object userName) {
    return 'QR-код считан. Пользователь: $userName';
  }

  @override
  String qr_code_processing_error(Object error) {
    return 'Ошибка обработки QR-кода: $error';
  }

  @override
  String get fill_all_fields => 'Заполните все поля';

  @override
  String connection_failed(Object error) {
    return 'Не удалось подключиться: $error';
  }

  @override
  String get authorization_success => 'Успешная авторизация';

  @override
  String get login_screen_title => 'Вход в систему';

  @override
  String get manual_input_title => 'ИЛИ ВВЕДИТЕ ДАННЫЕ ВРУЧНУЮ';

  @override
  String get emptySessions => 'Нет сеансов';

  @override
  String get emptyMedicines => 'Нет назначений медикаментов';

  @override
  String get error => 'Ошибка';

  @override
  String get appName => 'Отметка услуг (Медсестра)';

  @override
  String get choose => 'Выбрать';

  @override
  String get period => 'Период';

  @override
  String get choose_all => 'Выбрать все';

  @override
  String get remove_all => 'Снять все';

  @override
  String get no_cabinets => 'Нет доступных кабинетов';

  @override
  String get indicate_cabinets => 'Укажите рабочие кабинеты';

  @override
  String get choose_cabinets => 'Выбрать рабочие кабинеты';

  @override
  String get rendered_sessions => 'Оказанные услуги';
}
