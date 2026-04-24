
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medical_assistant/l10n/app_localizations.dart';
import 'package:medical_assistant/src/features/cabinets/cabinet.dart';
import 'package:medical_assistant/src/features/services/service.dart';
import 'package:medical_assistant/src/features/session_list/assigned_session.dart';
import 'package:medical_assistant/src/features/session_list/session_card.dart';

// Список сеансов
class SessionsWidgetList {
  // Список сеансов / загрузка / пустое сообщение
  // Вызывается для формирования списка при сканировании
  static List<Widget> sessionCardWidgets(BuildContext context, AsyncSnapshot<List<AssignedSession>> snapshot, List<AssignedSession> data, refreshParent,
      {selectedCabinet, selectedService, required bool showCompleted,
      void Function(List<AssignedSession>)? afterFilter}) {

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const [
        SliverToBoxAdapter(
          child: SizedBox(height: 150),
        ),
        SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ];
    }

    final filteredData = data.where((session) {
      final cabinetOk = selectedCabinet == null || selectedCabinet.value == null ||
          Cabinet.fromMap(session.room!) == selectedCabinet.value;

      final serviceOk = selectedService == null || selectedService.value == null ||
          Service.fromMap(session.service!) == selectedService.value;

      final tempVisibility = (session.temporaryVisibility ?? true) || showCompleted;

      return cabinetOk && serviceOk && tempVisibility && (!(session.isPassed == true || session.isNoShow == true) || showCompleted);
    }).toList();

    afterFilter?.call(filteredData);

    if (filteredData.isEmpty) {
      return [
        emptySessionWidget(context),
      ];
    }

    filteredData.sort((a, b) {
      int result = a.timeFrom?.compareTo(b.timeFrom ?? "") ?? 0;
      if (result != 0) return result;

      // Нужна дополнительная сортировка по другому полю, т.к. список будет прыгать при повторной сортировке с одинаковыми значениями
      // Плюс сортировка по пациентам внутри будет
      result = a.patient?["Наименование"].compareTo(b.patient?["Наименование"]);
      if (result != 0) return result;

      result = a.id.compareTo(b.id);
      return result;
    });

    return [
      SliverList(
        key: const PageStorageKey('sessions_list'),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return SessionCard(session: filteredData[index], refreshParent: refreshParent, showPassed: showCompleted);
          },
          childCount: filteredData.length,
        ),
      ),
    ];
  }

  static SliverToBoxAdapter emptySessionWidget(context) {
    return SliverToBoxAdapter(
      child: Center(
          child: Text(AppLocalizations.of(context)!.emptySessions)),
    );
  }
}