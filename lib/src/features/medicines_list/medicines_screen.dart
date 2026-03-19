
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_assistant/generated/l10n.dart';
import 'package:medical_assistant/src/features/medicines_list/medicine_card.dart';
import 'package:medical_assistant/src/features/menu/BottomMenu.dart';
import 'package:medical_assistant/src/network/synchronization.dart';

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreen();
}

class _MedicinesScreen extends State<MedicinesScreen> {
  Future<List<Map<String, dynamic>>> medicines = Synchronization().getMedicines();

  Widget BodyList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: medicines,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('${S.of(context).error}: ${snapshot.error}'));
        }

        final data = snapshot.data ?? [];

        if (data.isEmpty) {
          return Center(child: Text(S.of(context).emptyMedicines));
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => MedicineCard(medicine: data[index]),
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
        title: Text(S.of(context).medicines, style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: BodyList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BottomMenu(),
    );
  }
}