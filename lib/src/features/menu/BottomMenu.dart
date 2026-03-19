import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_assistant/generated/l10n.dart';
import 'package:medical_assistant/src/features/medicines_list/medicines_screen.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return menu(context);
  }

  Widget menu(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 3,
            spreadRadius: 3,
          ),
        ],
      ),
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            medicinesButton(context),
            qrcodeButton(context),
            sessionsButton(context),
          ],
        ),
      ),
    );
  }

  // Кнопка открытия списка медикаментов.
  Widget medicinesButton(BuildContext context) {
    return menuIcon(context, Icons.medication, S.of(context).medicines);
  }

  // Кнопка открытия QR-кода для отметки пациента.
  Widget qrcodeButton(BuildContext context) {
    return menuIcon(context, Icons.qr_code_2_rounded, S.of(context).qrcode);
  }

  // Кнопка открытия списка сеансов.
  Widget sessionsButton(BuildContext context) {
    return menuIcon(context, Icons.healing, S.of(context).sessions);
  }

  Widget menuIcon(BuildContext context, IconData icon, String text) {
    return Expanded(
      flex: 1,
      child: TextButton(
        style: ButtonStyle(),
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MedicinesScreen()));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Color.fromRGBO(0, 191, 255, 1), size: 40),
              Text(
                text,
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromRGBO(0, 191, 255, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
