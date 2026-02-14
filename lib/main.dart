import 'package:flutter/material.dart';
import 'package:medical_assistant/src/features/session_list/sessions_screen.dart';
import 'dart:ui' as ui;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medical_assistant/src/network/kint_api_exception.dart';
import 'generated/l10n.dart';

void main() {
  FlutterError.onError = errorHandler;
  runApp(const MyApp());
}

// Обработка ошибок
void errorHandler(dynamic error) {
  if (error is KintApiException){
    
  }
}

// Создание приложения
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: "Сеансы",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SessionsScreen()
    );
  }
}


