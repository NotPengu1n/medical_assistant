// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sessions => 'Sessions';

  @override
  String get medicines => 'Medicines';

  @override
  String get mark => 'Mark';

  @override
  String get noshow => 'No-show';

  @override
  String get cancel => 'Cancel';

  @override
  String get qrcode => 'QR-code';

  @override
  String get emptySessions => 'Sessions is empty';

  @override
  String get emptyMedicines => 'Medicines list is empty';

  @override
  String get error => 'Error';

  @override
  String get appName => 'Kint: Medical assistant';

  @override
  String get choose => 'Choose';
}
