
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Проводник по экранам
class AppNavigation {
  static const String sessionName = "/sessions";
  static const String cabinetsName = "/cabinets";
  static const String loginName = "/login";
  static const String splashName = "/splash";

  static void replaceScreen(Widget screen, BuildContext context) {
    try {
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => screen)
      );
    } catch (error){
      print(error);
    }
  }

  static void _replaceScreen(String screenName, BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(screenName, (route) => false);
  }

  static void openSessions(BuildContext context) {
    _replaceScreen(sessionName, context);
  }

  static void openCabinets(BuildContext context) {
    _replaceScreen(cabinetsName, context);
  }
}