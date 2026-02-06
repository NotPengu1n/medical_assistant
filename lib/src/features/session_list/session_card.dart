import 'package:flutter/material.dart';
import 'package:medical_assistant/generated/l10n.dart';

class SessionCard extends StatelessWidget {
  Map session = {};

  SessionCard({super.key, required this.session}){}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(255, 255, 255, 1)
      ),
      child: Column(
        children: [
          Text(session["guest"])
        ],
      ),
    );
  }
}