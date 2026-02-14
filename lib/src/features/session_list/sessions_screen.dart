import 'package:flutter/material.dart';
import 'package:medical_assistant/generated/l10n.dart';
import 'package:medical_assistant/src/features/session_list/session_card.dart';
import 'package:medical_assistant/src/network/synchronization.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionScreen();
}

class _SessionScreen extends State<SessionsScreen> {
  Future<List<Map<String, dynamic>>> sessions = Synchronization().getSessions();

  Widget BodyList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: sessions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        final data = snapshot.data ?? [];

        if (data.isEmpty) {
          return Center(child: Text('Нет сеансов'));
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => SessionCard(
            session: data[index],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 232, 232, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 191, 255, 1),
        title: Text(S.of(context).sessions),
      ),
      body: BodyList(),
      //bottomNavigationBar: menu(),
      floatingActionButton: menu(),
    );
  }

  Widget menu() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
        decoration: BoxDecoration(color: Colors.purpleAccent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("asd"),
            Text("saz")
          ],
        ),
      )
    );
  }
}
