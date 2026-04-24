import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @mark.
  ///
  /// In en, this message translates to:
  /// **'Mark'**
  String get mark;

  /// No description provided for @noshow.
  ///
  /// In en, this message translates to:
  /// **'No-show'**
  String get noshow;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @qrcode.
  ///
  /// In en, this message translates to:
  /// **'QR-code'**
  String get qrcode;

  /// No description provided for @scan_qrcode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR-code'**
  String get scan_qrcode;

  /// No description provided for @publication.
  ///
  /// In en, this message translates to:
  /// **'Publication'**
  String get publication;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @log_in.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get log_in;

  /// No description provided for @quick_login_qr.
  ///
  /// In en, this message translates to:
  /// **'Quick login via QR code'**
  String get quick_login_qr;

  /// No description provided for @qr_code_scanned_user.
  ///
  /// In en, this message translates to:
  /// **'QR code scanned. User: {userName}'**
  String qr_code_scanned_user(Object userName);

  /// No description provided for @qr_code_processing_error.
  ///
  /// In en, this message translates to:
  /// **'QR code processing error: {error}'**
  String qr_code_processing_error(Object error);

  /// No description provided for @fill_all_fields.
  ///
  /// In en, this message translates to:
  /// **'Fill in all fields'**
  String get fill_all_fields;

  /// No description provided for @connection_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect: {error}'**
  String connection_failed(Object error);

  /// No description provided for @authorization_success.
  ///
  /// In en, this message translates to:
  /// **'Authorization successful'**
  String get authorization_success;

  /// No description provided for @login_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_screen_title;

  /// No description provided for @manual_input_title.
  ///
  /// In en, this message translates to:
  /// **'OR ENTER DATA MANUALLY'**
  String get manual_input_title;

  /// No description provided for @emptySessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions is empty'**
  String get emptySessions;

  /// No description provided for @emptyMedicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines list is empty'**
  String get emptyMedicines;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Service marking (Nurse)'**
  String get appName;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @choose_all.
  ///
  /// In en, this message translates to:
  /// **'Choose all'**
  String get choose_all;

  /// No description provided for @remove_all.
  ///
  /// In en, this message translates to:
  /// **'Remove all'**
  String get remove_all;

  /// No description provided for @no_cabinets.
  ///
  /// In en, this message translates to:
  /// **'No cabinets'**
  String get no_cabinets;

  /// No description provided for @indicate_cabinets.
  ///
  /// In en, this message translates to:
  /// **'Indicate cabinets'**
  String get indicate_cabinets;

  /// No description provided for @choose_cabinets.
  ///
  /// In en, this message translates to:
  /// **'Choose work cabinets'**
  String get choose_cabinets;

  /// No description provided for @rendered_sessions.
  ///
  /// In en, this message translates to:
  /// **'Rendered sessions'**
  String get rendered_sessions;

  /// No description provided for @show_completed.
  ///
  /// In en, this message translates to:
  /// **'Show completed'**
  String get show_completed;

  /// No description provided for @change_user.
  ///
  /// In en, this message translates to:
  /// **'Change user'**
  String get change_user;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
