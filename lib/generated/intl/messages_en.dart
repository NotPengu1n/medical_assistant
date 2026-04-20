// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(error) => "Failed to connect: ${error}";

  static String m1(error) => "QR code processing error: ${error}";

  static String m2(userName) => "QR code scanned. User: ${userName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName":
            MessageLookupByLibrary.simpleMessage("Service marking (Nurse)"),
        "authorization_success":
            MessageLookupByLibrary.simpleMessage("Authorization successful"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "choose": MessageLookupByLibrary.simpleMessage("Choose"),
        "choose_all": MessageLookupByLibrary.simpleMessage("Choose all"),
        "choose_cabinets":
            MessageLookupByLibrary.simpleMessage("Choose work cabinets"),
        "connection_failed": m0,
        "emptyMedicines":
            MessageLookupByLibrary.simpleMessage("Medicines list is empty"),
        "emptySessions":
            MessageLookupByLibrary.simpleMessage("Sessions is empty"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "fill_all_fields":
            MessageLookupByLibrary.simpleMessage("Fill in all fields"),
        "indicate_cabinets":
            MessageLookupByLibrary.simpleMessage("Indicate cabinets"),
        "log_in": MessageLookupByLibrary.simpleMessage("Log in"),
        "login_screen_title": MessageLookupByLibrary.simpleMessage("Login"),
        "manual_input_title":
            MessageLookupByLibrary.simpleMessage("OR ENTER DATA MANUALLY"),
        "mark": MessageLookupByLibrary.simpleMessage("Mark"),
        "medicines": MessageLookupByLibrary.simpleMessage("Medicines"),
        "no_cabinets": MessageLookupByLibrary.simpleMessage("No cabinets"),
        "noshow": MessageLookupByLibrary.simpleMessage("No-show"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "period": MessageLookupByLibrary.simpleMessage("Period"),
        "publication": MessageLookupByLibrary.simpleMessage("Publication"),
        "qr_code_processing_error": m1,
        "qr_code_scanned_user": m2,
        "qrcode": MessageLookupByLibrary.simpleMessage("QR-code"),
        "quick_login_qr":
            MessageLookupByLibrary.simpleMessage("Quick login via QR code"),
        "remove_all": MessageLookupByLibrary.simpleMessage("Remove all"),
        "rendered_sessions":
            MessageLookupByLibrary.simpleMessage("Rendered sessions"),
        "scan_qrcode": MessageLookupByLibrary.simpleMessage("Scan QR-code"),
        "sessions": MessageLookupByLibrary.simpleMessage("Sessions"),
        "username": MessageLookupByLibrary.simpleMessage("Username")
      };
}
