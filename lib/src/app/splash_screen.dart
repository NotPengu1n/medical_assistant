import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_assistant/l10n/app_localizations.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_data.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_screen.dart';
import 'package:medical_assistant/src/features/login/authorization.dart';
import 'package:medical_assistant/src/features/login/login_screen.dart';
import 'package:medical_assistant/src/features/session_list/sessions_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Загрузка при запуске приложения. Определяем форму для открытия.
class _SplashScreenState extends State<SplashScreen> {
  // Кэширование нужно, чтобы при hot reload не выполнялась повторная загрузка
  static bool? _cachedAuthState;
  late Future<bool> _authFuture;

  static bool? hasSelectedCabinets;

  @override
  void initState() {
    super.initState();

    if (_cachedAuthState != null) {
      _authFuture = Future.value(_cachedAuthState);
    } else {
      _authFuture = Authorization.isAuthorized().then((value) {
        _cachedAuthState = value; // Сохраняем результат
        return value;
      });
    }

    hasSelectedCabinets = CabinetsData.hasSelected();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget(context);
        }

        // Проверка завершена - переходим на нужный экран
        if (snapshot.hasData) {
          final isAuthorized = snapshot.data ?? false;

          if (isAuthorized && !(hasSelectedCabinets ?? false)) {
            return CabinetsScreen();
          }

          if (isAuthorized) {
            return SessionsScreen();
          }
        }

        return LoginScreen();
      },
    );
  }

  // Форма загрузки.
  Widget loadingWidget(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlue],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Иконка приложения
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset("assets/brands/base_theme/logo.png"),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                AppLocalizations.of(context)!.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}