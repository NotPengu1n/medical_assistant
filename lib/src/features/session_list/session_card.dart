import 'package:flutter/material.dart';
import 'package:medical_assistant/generated/l10n.dart';
import 'package:intl/intl.dart';

// Карточка сеанса в списке сеансов
class SessionCard extends StatelessWidget {
  Map session = {};

  SessionCard({super.key, required this.session}) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: cardDecoration(),
      child: Column(children: [mainInfo(), disclosureInfo(context)]),
    );
  }

  // Основная видимая информация о сеансе
  Widget mainInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
      decoration: cardDecorationMainInfo(),
      child: Column(
        spacing: 5,
        children: [
          Row(children: [timeBox(), patientBox()]),
          Row(children: [serviceBox()]),
        ],
      ),
    );
  }

  // Скрытая информация о сеансе и кнопки сеанса
  Widget disclosureInfo(BuildContext context) {
    return Container(
      child: Column(
        spacing: 10,
        children: [
          Row(children: [Text(session["ПредставлениеПараметровНазначения"] ?? "")]),
          Row(children: [Text((session["Кабинет"]["Наименование"] ?? "") + ", " + (session["Оборудование"]["Наименование"] ?? ""))]),
          sessionButtons(context)
        ],
      ),
    );
  }

  Widget sessionButtons(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          sessionButton(Colors.redAccent, S.of(context).noshow),
          sessionButton(Colors.green, S.of(context).mark)
        ],
      ),
    );
  }

  Widget sessionButton(Color color, String text){
    return Container(
      padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
      decoration: BoxDecoration(
        color: color,
        borderRadius:  BorderRadius.circular(5)
      ),
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white))
    );
  }

  // Вывод услуги
  Widget serviceBox() {
    return Expanded(
      child: Text(
        session["Услуга"]["Наименование"],
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  // Вывод пациента
  Widget patientBox() {
    return Expanded(
      child: Text(
        session["Пациент"]["Наименование"],
        softWrap: true,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  // Вывод времени сеанса
  Container timeBox() {
    String time = DateFormat("HH:mm").format(DateTime.parse(session["ВремяС"]));

    return Container(
      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 191, 255, 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        time,
        style: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Стиль оформления карточки сеанса
  BoxDecoration cardDecorationMainInfo() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Color.fromRGBO(255, 255, 255, 1),
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.3),
          blurRadius: 2,
          spreadRadius: 1,
        ),
      ],
    );
  }

  BoxDecoration cardDecoration(){
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white70,
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.3),
          blurRadius: 2,
          spreadRadius: 1
        ),
      ],
    );
  }
}
