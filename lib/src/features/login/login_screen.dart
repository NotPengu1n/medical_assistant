import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medical_assistant/l10n/app_localizations.dart';
import 'package:medical_assistant/src/data/auth_data_manager.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_screen.dart';
import 'package:medical_assistant/src/features/login/authorization.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:medical_assistant/ui_kit/ui_kit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _publicationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initializeFields();
  }

  void initializeFields() async {
    AuthDataManager auth = await AuthDataManager.getAuthData();
    _publicationController.text = auth.publication ?? "";
    _usernameController.text = auth.user ?? "";
  }

  @override
  void dispose() {
    _publicationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleQRScan() async {
    // Показываем диалог со сканером QR-кода
    showDialog(
      context: context,
      barrierDismissible: false, // Не даем закрыть диалог случайным нажатием
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          height: 400,
          width: double.maxFinite,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.scan_qrcode,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        final String? qrData = barcodes.first.rawValue;
                        if (qrData != null) {
                          Navigator.pop(context);
                          _processQRData(qrData);
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  // Обработка считывания QR-кода
  void _processQRData(String qrData) {
    try {
      final Map<String, dynamic> qrJson = jsonDecode(qrData);

      String? publicationUrl = qrJson['url'];
      String? userName = qrJson['app_usr']?['Name'];

      setState(() {
        if (publicationUrl != null) {
          _publicationController.text = publicationUrl;
        }
        if (userName != null) {
          _usernameController.text = userName;
        }
      });

      showMessage(AppLocalizations.of(context)!.qr_code_scanned_user(userName!));
    } catch (error) {
      showMessage(AppLocalizations.of(context)!.qr_code_processing_error(error), isError: true);
    }
  }

  void showMessage(String text, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: (isError ? Colors.red : Colors.green),
        duration: Duration(seconds: 10),
      ),
    );
  }

  // Обработка нажатия кнопки входа
  Future<void> _handleLogin() async {
    if (_publicationController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      showMessage(AppLocalizations.of(context)!.fill_all_fields, isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    AuthDataManager auth = AuthDataManager.withParams(_publicationController.text, _usernameController.text, _passwordController.text);

    try {
      await Authorization.checkAuthorization(auth);
    }
    catch (error) {
      showMessage(AppLocalizations.of(context)!.connection_failed(error), isError: true);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
    });

    showMessage(AppLocalizations.of(context)!.authorization_success);

    auth.save(); // Сохранение данных авторизации
    await auth.syncEmployee();

    // TODO: здесь надо открывать форму общей функцией. Скорее всего надо использовать SplashScreen(), т.к. там общий код
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CabinetsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login_screen_title),
        centerTitle: true,
        backgroundColor: AppT.c.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              QRButton(),

              const Divider(height: 40),

              Text(
                AppLocalizations.of(context)!.manual_input_title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 24),

              publicationField(),
              const SizedBox(height: 16),

              userField(),
              const SizedBox(height: 16),

              passwordField(),
              const SizedBox(height: 24),

              loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Поле "Пароль"
  Widget passwordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.password,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  // Кнопка сканирования QR-кода
  Widget QRButton() {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: _handleQRScan,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppT.c.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.scan_qrcode,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.quick_login_qr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Кнопка "Войти"
  Widget loginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppT.c.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: _isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
          : Text(
        AppLocalizations.of(context)!.log_in,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // Поле "Пользователь"
  Widget userField() {
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.username,
        prefixIcon: const Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  // Поле "Публикация"
  Widget publicationField() {
    return TextField(
      controller: _publicationController,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.publication,
        prefixIcon: const Icon(Icons.public),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}