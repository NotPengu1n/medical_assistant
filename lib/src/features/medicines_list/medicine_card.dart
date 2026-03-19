
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget{
  Map<String, dynamic> medicine = {};

  MedicineCard({super.key, required this.medicine}) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: cardDecoration(),
      child: Column(
          children: [
            Text(medicine["Пациент"]["Наименование"]),
            Text(medicine["Номенклатура"]["Наименование"])
          ]
      ),
    );
  }

  BoxDecoration cardDecoration(){
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
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