import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medical_assistant/generated/l10n.dart';
import 'package:medical_assistant/src/app/app_navigation.dart';
import 'package:medical_assistant/src/features/cabinets/cabinet.dart';
import 'package:medical_assistant/src/features/cabinets/cabinets_data.dart';
import 'package:medical_assistant/src/app/splash_screen.dart';
import 'package:medical_assistant/src/features/session_list/sessions_screen.dart';

// Форма выбора кабинетов
class CabinetsScreen extends StatefulWidget {
  const CabinetsScreen({super.key});

  @override
  State<CabinetsScreen> createState() => _CabinetsScreen();
}

class _CabinetsScreen extends State<CabinetsScreen> {
  late Future<List<Cabinet>> _cabinetsFuture;

  @override
  void initState() {
    super.initState();
    _cabinetsFuture = CabinetsData.getCabinetsToChoose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Укажите рабочие кабинеты',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Cabinet>>(
        future: _cabinetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).error,
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                  ),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final cabinets = snapshot.data ?? [];

          if (cabinets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.meeting_room_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Нет доступных кабинетов',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          return ValueListenableBuilder<Box<Cabinet>>(
            valueListenable: Hive.box<Cabinet>(CabinetsData.name).listenable(),
            builder: (context, Box<Cabinet> box, _) {
              return Column(
                children: [
                  _buildActionButtons(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cabinets.length,
                      itemBuilder: (context, index) {
                        final cabinet = cabinets[index];
                        return _buildCabinetTile(cabinet);
                      },
                    ),
                  ),
                  _buildBottomButton(context, box),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCabinetTile(Cabinet cabinet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CheckboxListTile(
        value: cabinet.isSelected,
        onChanged: (bool? value) {
          setState(() {
            cabinet.isSelected = value ?? false;
            CabinetsData.save(cabinet);
          });
        },
        title: Text(
          cabinet.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.meeting_room,
            color: Colors.blue.shade700,
            size: 20,
          ),
        ),
        activeColor: Colors.blue,
        checkColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, Box<Cabinet> box) {
    final selectedCount = box.values.where((c) => c.isSelected).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: selectedCount > 0 ? () {
            AppNavigation.openSessions(context);
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'ОК',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _selectAll,
              icon: const Icon(Icons.check_box, size: 18),
              label: const Text('Выбрать все'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue.shade700,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _deselectAll,
              icon: const Icon(Icons.check_box_outline_blank, size: 18),
              label: const Text('Снять все'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade50,
                foregroundColor: Colors.grey.shade700,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Обработка команды выбора всех кабинетов
  void _selectAll() {
    final _cabinets = CabinetsData.getCabinets();
    for (var cabinet in _cabinets) {
      if (!cabinet.isSelected) {
        cabinet.isSelected = true;
        CabinetsData.save(cabinet);
      }
    }
    setState(() {});
  }

  // Обработка команды снятия пометки всех кабинетов
  void _deselectAll() {
    final _cabinets = CabinetsData.getCabinets();
    for (var cabinet in _cabinets) {
      if (cabinet.isSelected ?? false) {
        cabinet.isSelected = false;
        CabinetsData.save(cabinet);
      }
    }
    setState(() {});
  }
}