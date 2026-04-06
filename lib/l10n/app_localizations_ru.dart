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
  String get emptySessions => 'Нет сеансов';

  @override
  String get emptyMedicines => 'Нет назначений медикаментов';

  @override
  String get error => 'Ошибка';

  @override
  String get appName => 'Кинт: Медсестра';

  @override
  String get choose => 'Выбрать';
}
