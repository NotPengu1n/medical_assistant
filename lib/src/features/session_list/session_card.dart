
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_assistant/l10n/app_localizations.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';
import 'package:medical_assistant/src/core/extended_string/ext_string.dart';
import 'package:medical_assistant/src/core/sprite_icon/sprite_icon.dart';
import 'package:medical_assistant/src/network/synchronization.dart';

class SessionCard extends StatefulWidget {
  final Map session;

  SessionCard({super.key, required this.session}) {
    session["Дата"] = session["ДатаСеанса"];
    session["Исполнитель"] = null;
    session["фПлатная"] = session["Платная"];
  }

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  bool isPassed = false;
  bool isNoShow = false;
  bool isVisible = true;
  bool isFutureSession = false;
  bool isPaid = false;
  bool hasBeenPaid = false;
  int seatsNumber = 0;
  bool isDisclosureVisible = false;

  int iconPriorityId = 0;
  String priority = "";

  @override
  void initState() {
    super.initState();

    DateTime sessionDate = DateTime.parse(widget.session["ДатаСеанса"]);

    isPassed = widget.session["isPassed"];
    isNoShow = widget.session["isNoShow"];
    isFutureSession = sessionDate.beginOfDay().isAfter(
      DateTime.now().beginOfDay(),
    );
    seatsNumber = widget.session["Мест"] ?? 0;

    iconPriorityId = widget.session["НомерИконкиФизлица"] ?? 0;
    priority = widget.session["ПредставлениеМетки"] ?? "";

    isPaid = widget.session["фПлатная"] ?? false;
    hasBeenPaid = widget.session["фОплачено"] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Visibility(
      visible: isVisible,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        decoration: cardDecoration(),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: swipeBody(context, borderRadius), // TODO: удалить переменную borderRadius
        ),
      ),
    );
  }

  // Тело сеанса, которое можно свайпать
  Widget swipeBody(BuildContext context, BorderRadius borderRadius) {
    return Dismissible(
      key: ValueKey(widget.session["id"]),
      direction: DismissDirection.horizontal,

      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          // свайп влево "Отметить"
          setState(() {
            isVisible = false;
          });
        } else if (direction == DismissDirection.startToEnd) {
          // свайп вправо "Неявка"
          setState(() {
            isVisible = false;
          });
        }
      },

      background: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: borderRadius,
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppLocalizations.of(context)!.noshow,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      secondaryBackground: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: borderRadius,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppLocalizations.of(context)!.mark,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      child: sessionBody(context, borderRadius),
    );
  }

  // Тело сеанса
  Widget sessionBody(BuildContext context, BorderRadius borderRadius) {
    return ClipRRect(
      borderRadius: borderRadius,

      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: borderRadius,
              onTap: () {
                setState(() {
                  isDisclosureVisible = !isDisclosureVisible;
                });
              },
              child: mainInfo(),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isDisclosureVisible
                  ? disclosureInfo(context)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // Основная информация по сеансу
  Widget mainInfo() {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: mainInfoDecoration(),
        child: IntrinsicHeight(child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  patientBox(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      timeBox(),
                      const SizedBox(width: 5),
                      serviceBox()
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (iconPriorityId > 0) ...[iconPriority()],
                if (isPaid) ...[iconPaidInfo()]
              ],
            ),
          ],
        ))
    );
  }

  // Дополнительная информация по сеансу
  Widget disclosureInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: disclosureInfoDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              if (isPaid) ...[paidInfoWidget()],
              if (seatsNumber > 1) ...[seatsNumberWidget(context)],
              if (iconPriorityId > 0) ...[Row(children: [iconPriority(), const SizedBox(width: 6), Text(priority)])],
            ],
          ),

          locationWidget(context),

          sessionButtons(context),
        ],
      ),
    );
  }

  // Параметры назначения
  String assignmentParametrs() {
    String value = widget.session["ПредставлениеПараметровНазначения"];
    if (value.isEmpty) return "";
    return ' • $value';
  }

  // Виджет количество мест
  Widget seatsNumberWidget(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.event_seat_outlined, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          '$seatsNumber ' + "".pluralForm(seatsNumber, "место", "места", "мест"),
          style: TextStyle(fontSize: 13, color: Colors.grey[800]),
        ),
      ],
    );
  }

  // Виджет место оказания услуги
  Widget locationWidget(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.meeting_room_outlined, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            getLocationText(),
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  // Место оказания услуги
  String getLocationText() {
    String cabinet = widget.session["Кабинет"]?["Наименование"] ?? "";
    String equipment = widget.session["Оборудование"]?["Наименование"] ?? "";

    if (cabinet.isEmpty && equipment.isEmpty) return "Местоположение не указано";
    if (cabinet.isEmpty) return equipment;
    if (equipment.isEmpty) return cabinet;
    return "$cabinet • $equipment";
  }

  // Кнопки сеанса
  Widget sessionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        sessionButton(
          context,
          Colors.red.shade400,
          AppLocalizations.of(context)!.noshow,
          cancelSession,
        ),
        const SizedBox(width: 8),
        sessionButton(context, Colors.blue, AppLocalizations.of(context)!.mark, markSession),
      ],
    );
  }

  // Обработчик команды отметки сеанса
  Future<void> markSession() async {
    bool result = await Synchronization.markSession(
      widget.session,
      false,
      false,
    );
    if (result && mounted) {
      setState(() {
        isVisible = false;
        widget.session["Пройдено"] = 1;
      });
    }
  }

  // Обработчик команды неявки на сеанс
  Future<void> cancelSession() async {
    bool result = await Synchronization.markSession(
      widget.session,
      true,
      false,
    );
    if (result && mounted) {
      setState(() {
        isVisible = false;
        widget.session["Осталось"] = 0;
      });
    }
  }

  // Описание кнопки сеанса
  Widget sessionButton(BuildContext context, Color color, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Виджет услуги
  Widget serviceBox() {
    String serviceName = (widget.session["Услуга"]?["Наименование"] ?? "Услуга не указана") + assignmentParametrs();

    return Text(
      serviceName,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Виджет пациента
  Widget patientBox() {
    String patientName =
        widget.session["Пациент"]?["Наименование"] ?? "Пациент не указан";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          patientName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.session["Комментарий"] != null &&
            widget.session["Комментарий"].toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              widget.session["Комментарий"],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  // Время сеанса
  Widget timeBox() {
    DateTime time = widget.session["ВремяС"];
    String strTime = (time.isEmpty()
        ? "--:--"
        : DateFormat("HH:mm").format(time));

    return Text(
      strTime,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.blue,
      ),
    );
  }

  // Информация об оплате
  Widget paidInfoWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        children: [
          iconPaidInfo(),
          const SizedBox(width: 6),
          Text(
            hasBeenPaid ? 'Оплачено' : 'Ожидает оплаты',
            style: TextStyle(
              fontSize: 13,
              fontWeight: hasBeenPaid ? FontWeight.w500 : FontWeight.normal,
              color: hasBeenPaid
                  ? Colors.green.shade700
                  : Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // Иконка приоритета гостя
  Widget iconPriority() {
    return SpriteIcon(index: iconPriorityId, image: "яъКоллекцияПриоритетов_upscaled_x4.png", size: 64);
  }

  // Иконка оплаты
  Widget iconPaidInfo() {
    return Text(
      '₽',
      style: TextStyle(fontSize: 16, color: (hasBeenPaid ? Colors.green.shade700 : Colors.orange.shade700)),
    );
  }

  // Стиль оформления основной карточки
  BoxDecoration mainInfoDecoration() {
    return BoxDecoration(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    );
  }

  // Стиль оформления дополнительной карточки
  BoxDecoration disclosureInfoDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade50,
      border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
    );
  }

  // Стиль оформления всей карточки сеанса
  BoxDecoration cardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
    );
  }
}
