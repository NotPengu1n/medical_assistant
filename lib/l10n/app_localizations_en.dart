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
  String get scan_qrcode => 'Scan QR-code';

  @override
  String get publication => 'Publication';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get log_in => 'Log in';

  @override
  String get quick_login_qr => 'Quick login via QR code';

  @override
  String qr_code_scanned_user(Object userName) {
    return 'QR code scanned. User: $userName';
  }

  @override
  String qr_code_processing_error(Object error) {
    return 'QR code processing error: $error';
  }

  @override
  String get fill_all_fields => 'Fill in all fields';

  @override
  String connection_failed(Object error) {
    return 'Failed to connect: $error';
  }

  @override
  String get authorization_success => 'Authorization successful';

  @override
  String get login_screen_title => 'Login';

  @override
  String get manual_input_title => 'OR ENTER DATA MANUALLY';

  @override
  String get emptySessions => 'Sessions is empty';

  @override
  String get emptyMedicines => 'Medicines list is empty';

  @override
  String get error => 'Error';

  @override
  String get appName => 'Service marking (Nurse)';

  @override
  String get choose => 'Choose';

  @override
  String get period => 'Period';

  @override
  String get choose_all => 'Choose all';

  @override
  String get remove_all => 'Remove all';

  @override
  String get no_cabinets => 'No cabinets';

  @override
  String get indicate_cabinets => 'Indicate cabinets';

  @override
  String get choose_cabinets => 'Choose work cabinets';

  @override
  String get rendered_sessions => 'Rendered sessions';

  @override
  String get show_completed => 'Show completed';

  @override
  String get change_user => 'Change user';
}
