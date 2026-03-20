import 'package:flutter/material.dart';
import 'package:medical_assistant/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';
import 'package:medical_assistant/src/core/extended_string/ext_string.dart';
import 'package:medical_assistant/src/core/sprite_icon/sprite_icon.dart';
import 'package:medical_assistant/src/network/synchronization.dart';

class SessionCard extends StatefulWidget {
  Map session = {};

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

  int iconPriorityId = 0;
  String priority = "";

  @override
  void initState() {
    super.initState();

    DateTime sessionDate = DateTime.parse(widget.session["ДатаСеанса"]);
    DateTime now = DateTime.now();

    isPassed = (widget.session["Пройдено"] as int >= 1);
    isNoShow = (widget.session["Пройдено"] as int == 0 && widget.session["Осталось"] as int == 0);
    isFutureSession = sessionDate.beginOfDay().isAfter(DateTime.now().beginOfDay());
    seatsNumber = widget.session["Мест"] ?? 0;
    isVisible = !(isPassed || isNoShow);

    iconPriorityId = widget.session["НомерИконкиФизлица"] ?? 0;
    priority = widget.session["ПредставлениеМетки"] ?? "";

    isPaid = widget.session["фПлатная"] ?? false;
    hasBeenPaid = widget.session["фОплачено"] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        decoration: cardDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainInfo(),
              disclosureInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  // Основная информация по сеансу
  Widget mainInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: mainInfoDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              timeBox(),
              const SizedBox(width: 12),
              Expanded(child: patientBox()),
              SpriteIcon(index: iconPriorityId, image: "яъКоллекцияПриоритетов.png")
            ],
          ),
          const SizedBox(height: 8),
          serviceBox(),
        ],
      ),
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
          if (widget.session["ПредставлениеПараметровНазначения"] != null &&
              widget.session["ПредставлениеПараметровНазначения"].toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.note_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.session["ПредставлениеПараметровНазначения"],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Row(
            spacing: 10,
            children: [
              if (isPaid) ...[
                paidInfoWidget()
              ],
              if (seatsNumber > 0) ...[ // TODO: возможно надо не отображать одно место, т.к. ситуация редкая.
                seatsNumberWidget(context),
              ],
            ]
          ),

          locationWidget(context),

          sessionButtons(context),
        ],
      ),
    );
  }

  // Виджет количество мест
  Widget seatsNumberWidget(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.event_seat_outlined, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          '$seatsNumber ' + "".pluralForm(seatsNumber, "место", "места", "мест"),
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[800],
          ),
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
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
            ),
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
          S.of(context).noshow,
          cancelSession,
        ),
        const SizedBox(width: 8),
        sessionButton(
          context,
          Colors.blue,
          S.of(context).mark,
          markSession,
        ),
      ],
    );
  }

  // Обработчик команды отметки сеанса
  Future<void> markSession() async {
    bool result = await Synchronization.markSession(widget.session, false, false);
    if (result && mounted) {
      setState(() {
        isVisible = false;
        widget.session["Пройдено"] = 1;
      });
    }
  }

  // Обработчик команды неявки на сеанс
  Future<void> cancelSession() async {
    bool result = await Synchronization.markSession(widget.session, true, false);
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Виджет услуги
  Widget serviceBox() {
    String serviceName = widget.session["Услуга"]?["Наименование"] ?? "Услуга не указана";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Text(
        serviceName,
        style: TextStyle(
          fontSize: 13,
          color: Colors.blue.shade800,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Виджет пациента
  Widget patientBox() {
    String patientName = widget.session["Пациент"]?["Наименование"] ?? "Пациент не указан";

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
    DateTime time = DateTime.parse(widget.session["ВремяС"]);
    String strTime = (time.isEmpty() ? "--:--" : DateFormat("HH:mm").format(time));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue,
            Colors.blue.shade700,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            strTime,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Информация об оплате
  Widget paidInfoWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        children: [
          if (hasBeenPaid) ...[Text('₽', style: TextStyle(fontSize: 16, color: Colors.green.shade700))]
          else ...[Icon(Icons.payment_outlined, size: 16, color: Colors.orange.shade700,)],
          const SizedBox(width: 6),
          Text(
            hasBeenPaid ? 'Оплачено' : 'Ожидает оплаты',
            style: TextStyle(
              fontSize: 13,
              fontWeight: hasBeenPaid ? FontWeight.w500 : FontWeight.normal,
              color: hasBeenPaid ? Colors.green.shade700 : Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // Стиль оформления основной карточки
  BoxDecoration mainInfoDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    );
  }

  // Стиль оформления дополнительной карточки
  BoxDecoration disclosureInfoDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade50,
      border: Border(
        top: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
    );
  }

  // Стиль оформления всей карточки сеанса
  BoxDecoration cardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
    );
  }
}