import 'package:flutter/material.dart';
import 'package:medical_assistant/generated/l10n.dart';
import 'package:intl/intl.dart';

// Карточка сеанса в списке сеансов
class SessionCard extends StatelessWidget {
  Map session = {};

  SessionCard({super.key, required this.session}){}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
      decoration: cardDecoration(),
      child: Column(
        spacing: 5,
        children: [
          Row(
              children: [
                timeBox(),
                patientBox()
              ]
          ),
          Row(
              children: [
                serviceBox()
              ]
          )
        ],
      ),
    );
  }

  // Вывод услуги
  Expanded serviceBox() {
    return Expanded(
        child: Text(session["Услуга"]["Наименование"])
    );
  }

  // Вывод пациента
  Expanded patientBox() {
    return Expanded(
        child: Text(
            session["Пациент"]["Наименование"],
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold)
        )
    );
  }

  // Вывод времени сеанса
  Container timeBox() {
    String time = DateFormat("HH:mm").format(DateTime.parse(session["ВремяС"]));

    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 191, 255, 1),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Text(time,
        style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontWeight: FontWeight.bold)
      )
    );
  }

  // Стиль оформления карточки сеанса
  BoxDecoration cardDecoration(){
    return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(255, 255, 255, 1),
        boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 3, spreadRadius: 3)]
    );
  }
}