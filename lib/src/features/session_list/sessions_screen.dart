import 'package:flutter/material.dart';
import 'package:medical_assistant/generated/l10n.dart';
import 'package:medical_assistant/src/features/session_list/session_card.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionScreen();
}

class _SessionScreen extends State<SessionsScreen> {
  dynamic sessions = [
    {"guest": "Макадзару Герхальд Бананович"},
    {"guest": "Пушкин Александр Сергеевич"}
  ];

  ListView BodyList() {
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) => SessionCard(session: sessions[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 191, 255, 1),
        title: Text(S.of(context).sessions),
      ),
      body: BodyList()
    );
  }
}
