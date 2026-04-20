
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medical_assistant/src/app/splash_screen.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_screen.dart';
import 'package:medical_assistant/src/features/login/login_screen.dart';
import 'package:medical_assistant/src/features/rendered_services/rendered_services.dart';
import 'package:medical_assistant/src/features/session_list/qr_screen.dart';
import 'package:medical_assistant/src/features/session_list/sessions_screen.dart';

// Проводник по экранам
class AppNavigation {
  static const String sessionName = "/sessions";
  static const String cabinetsName = "/cabinets";
  static const String loginName = "/login";
  static const String splashName = "/splash";
  static const String renderedServicesName = "/renderedServices";
  static const String qrName = "/qr";

  static Map<String, WidgetBuilder> routes() {
    return {
      splashName : (context) => SplashScreen(),
      loginName: (context) => LoginScreen(),
      sessionName: (context) => SessionsScreen(),
      cabinetsName: (context) => CabinetsScreen(),
      renderedServicesName: (context) => ServicesReportPage(),
    };
  }

  static void replaceScreen(Widget screen, BuildContext context) {
    try {
      Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => screen)
      );
    } catch (error){
      print(error);
    }
  }

  static void _openScreen(String screenName, BuildContext context) {
    Navigator.of(context).pushNamed(screenName);
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

  static void openRenderedServices(BuildContext context) {
    _openScreen(renderedServicesName, context);
  }
}