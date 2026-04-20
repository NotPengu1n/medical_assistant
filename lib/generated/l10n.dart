// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sessions`
  String get sessions {
    return Intl.message(
      'Sessions',
      name: 'sessions',
      desc: '',
      args: [],
    );
  }

  /// `Medicines`
  String get medicines {
    return Intl.message(
      'Medicines',
      name: 'medicines',
      desc: '',
      args: [],
    );
  }

  /// `Mark`
  String get mark {
    return Intl.message(
      'Mark',
      name: 'mark',
      desc: '',
      args: [],
    );
  }

  /// `No-show`
  String get noshow {
    return Intl.message(
      'No-show',
      name: 'noshow',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `QR-code`
  String get qrcode {
    return Intl.message(
      'QR-code',
      name: 'qrcode',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR-code`
  String get scan_qrcode {
    return Intl.message(
      'Scan QR-code',
      name: 'scan_qrcode',
      desc: '',
      args: [],
    );
  }

  /// `Publication`
  String get publication {
    return Intl.message(
      'Publication',
      name: 'publication',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get log_in {
    return Intl.message(
      'Log in',
      name: 'log_in',
      desc: '',
      args: [],
    );
  }

  /// `Quick login via QR code`
  String get quick_login_qr {
    return Intl.message(
      'Quick login via QR code',
      name: 'quick_login_qr',
      desc: '',
      args: [],
    );
  }

  /// `QR code scanned. User: {userName}`
  String qr_code_scanned_user(Object userName) {
    return Intl.message(
      'QR code scanned. User: $userName',
      name: 'qr_code_scanned_user',
      desc: '',
      args: [userName],
    );
  }

  /// `QR code processing error: {error}`
  String qr_code_processing_error(Object error) {
    return Intl.message(
      'QR code processing error: $error',
      name: 'qr_code_processing_error',
      desc: '',
      args: [error],
    );
  }

  /// `Fill in all fields`
  String get fill_all_fields {
    return Intl.message(
      'Fill in all fields',
      name: 'fill_all_fields',
      desc: '',
      args: [],
    );
  }

  /// `Failed to connect: {error}`
  String connection_failed(Object error) {
    return Intl.message(
      'Failed to connect: $error',
      name: 'connection_failed',
      desc: '',
      args: [error],
    );
  }

  /// `Authorization successful`
  String get authorization_success {
    return Intl.message(
      'Authorization successful',
      name: 'authorization_success',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_screen_title {
    return Intl.message(
      'Login',
      name: 'login_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `OR ENTER DATA MANUALLY`
  String get manual_input_title {
    return Intl.message(
      'OR ENTER DATA MANUALLY',
      name: 'manual_input_title',
      desc: '',
      args: [],
    );
  }

  /// `Sessions is empty`
  String get emptySessions {
    return Intl.message(
      'Sessions is empty',
      name: 'emptySessions',
      desc: '',
      args: [],
    );
  }

  /// `Medicines list is empty`
  String get emptyMedicines {
    return Intl.message(
      'Medicines list is empty',
      name: 'emptyMedicines',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Service marking (Nurse)`
  String get appName {
    return Intl.message(
      'Service marking (Nurse)',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message(
      'Choose',
      name: 'choose',
      desc: '',
      args: [],
    );
  }

  /// `Period`
  String get period {
    return Intl.message(
      'Period',
      name: 'period',
      desc: '',
      args: [],
    );
  }

  /// `Choose all`
  String get choose_all {
    return Intl.message(
      'Choose all',
      name: 'choose_all',
      desc: '',
      args: [],
    );
  }

  /// `Remove all`
  String get remove_all {
    return Intl.message(
      'Remove all',
      name: 'remove_all',
      desc: '',
      args: [],
    );
  }

  /// `No cabinets`
  String get no_cabinets {
    return Intl.message(
      'No cabinets',
      name: 'no_cabinets',
      desc: '',
      args: [],
    );
  }

  /// `Indicate cabinets`
  String get indicate_cabinets {
    return Intl.message(
      'Indicate cabinets',
      name: 'indicate_cabinets',
      desc: '',
      args: [],
    );
  }

  /// `Choose work cabinets`
  String get choose_cabinets {
    return Intl.message(
      'Choose work cabinets',
      name: 'choose_cabinets',
      desc: '',
      args: [],
    );
  }

  /// `Rendered sessions`
  String get rendered_sessions {
    return Intl.message(
      'Rendered sessions',
      name: 'rendered_sessions',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
