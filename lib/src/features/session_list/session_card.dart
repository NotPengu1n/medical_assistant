
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_assistant/l10n/app_localizations.dart';
import 'package:medical_assistant/src/core/extended_date_time/ext_date_time.dart';
import 'package:medical_assistant/src/core/extended_string/ext_string.dart';
import 'package:medical_assistant/src/core/sprite_icon/sprite_icon.dart';
import 'package:medical_assistant/src/network/synchronization.dart';
import 'package:medical_assistant/ui_kit/ui_kit.dart';

class SessionCard extends StatefulWidget {
  final Map session;
  bool isVisible = true;
  final VoidCallback refreshParent;

  SessionCard({super.key, required this.session, required this.refreshParent}) {
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
  bool isFutureSession = false;
  bool isPaid = false;
  bool hasBeenPaid = false;
  int seatsNumber = 0;
  bool isDisclosureVisible = false;
  final borderRadius = BorderRadius.circular(AppT.r.lg);
  final paddingCard = EdgeInsets.symmetric(horizontal: AppT.r.lg, vertical: AppT.r.lg / 2);

  int iconPriorityId = 0;
  String priority = "";

  @override
  void initState() {
    super.initState();
  }

  // Инициализация переменных класса
  void initializeVariables() {
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
    initializeVariables();

    return Visibility(
      key: ValueKey(widget.session["id"]),
      visible: widget.isVisible,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        decoration: cardDecoration(),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: swipeBody(context), // TODO: удалить переменную borderRadius
        ),
      ),
    );
  }

  // Тело сеанса, которое можно свайпать
  Widget swipeBody(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.session["id"]),
      direction: DismissDirection.horizontal,

      confirmDismiss: (direction) async {
        return true;
      },

      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          markSession(); // Влево - оказываем услугу
        } else if (direction == DismissDirection.startToEnd) {
          cancelSession(); // Вправо - неявка на услугу
        }
      },

      background: _buildDismissBackground(
        borderRadius: borderRadius,
        color: AppT.c.error,
        alignment: Alignment.centerLeft,
        text: AppLocalizations.of(context)!.noshow,
      ),

      secondaryBackground: _buildDismissBackground(
        borderRadius: borderRadius,
        color: AppT.c.primary,
        alignment: Alignment.centerRight,
        text: AppLocalizations.of(context)!.mark,
      ),

      child: sessionBody(context, borderRadius),
    );
  }

  // Фон свайпера
  Widget _buildDismissBackground({
    required BorderRadius borderRadius,
    required Color color,
    required Alignment alignment,
    required String text,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        alignment: alignment,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          text,
          style: TextStyle(
            color: AppT.c.surface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
        padding: paddingCard,
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
                      Expanded(child: serviceBox())
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
      padding: paddingCard,
      decoration: disclosureInfoDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              if (isPaid) ...[paidInfoWidget()],
              if (seatsNumber > 1) ...[seatsNumberWidget(context)],
              if (iconPriorityId > 0) ...[Row(children: [iconPriority(), const SizedBox(width: 6), Text(priority, style: TextStyle(color: AppT.c.textSecondary),)])],
            ],
          ),

          locationWidget(context),

          ...commentBox(),

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
        Icon(Icons.event_seat_outlined, size: 16, color: AppT.c.textSecondary),
        const SizedBox(width: 6),
        Text(
          '$seatsNumber ' + "".pluralForm(seatsNumber, "место", "места", "мест"),
          style: TextStyle(fontSize: 13, color: AppT.c.textSecondary),
        ),
      ],
    );
  }

  // Виджет место оказания услуги
  Widget locationWidget(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.meeting_room_outlined, size: 16, color: AppT.c.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            getLocationText(),
            style: TextStyle(fontSize: 13, color: AppT.c.textSecondary),
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
        sessionButton(context, AppT.c.error, AppLocalizations.of(context)!.noshow, cancelSession),
        const SizedBox(width: 8),
        sessionButton(context, AppT.c.primary, AppLocalizations.of(context)!.mark, markSession),
      ],
    );
  }

  Future<bool> _handleSessionAction({required bool isCancel, required void Function() onSuccess}) async {
    try {
      // setState(() {
      //   widget.isVisible = false;
      // });

      widget.session["ВременнаяВидимость"] = false;
      widget.refreshParent();

      final result = await Synchronization.markSession(widget.session, isCancel, false);

      if (result && mounted) {
        widget.session["ВременнаяВидимость"] = true; // Возвращаем флаг назад, т.к. флаг временный. После этого видимость определяется другими параметрами
        setState(onSuccess);
      }
    } catch (error) {
      // setState(() {
      //   widget.isVisible = true;
      // });
      showMessage(error.toString(), isError: true);
      widget.session["ВременнаяВидимость"] = true;
      widget.refreshParent();
      return false;
    }

    return true;
  }

  // Обработчик команды отметки сеанса
  Future<bool> markSession() async {
    return _handleSessionAction(
      isCancel: false,
      onSuccess: () {
        widget.session["Пройдено"] = 1;
      },
    );
  }

  // Обработчик команды неявки на сеанс
  Future<bool> cancelSession() async {
    return _handleSessionAction(
      isCancel: true,
      onSuccess: () {
        widget.session["Осталось"] = 0;
      },
    );
  }

  // TODO: вынести в общий модуль
  void showMessage(String text, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: (isError ? AppT.c.error : AppT.c.success),
        duration: Duration(seconds: 10),
        padding: EdgeInsets.only(bottom: 30),
      ),
    );
  }

  // Описание кнопки сеанса
  Widget sessionButton(BuildContext context, Color color, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppT.c.surface,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
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
        color: AppT.c.textSecondary,
      ),
      maxLines: isDisclosureVisible ? 5 : 1,
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
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppT.c.textPrimary,
          ),
          maxLines: isDisclosureVisible ? 5 : 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  // Виджет комментарий
  List<Widget> commentBox() {
    String comment = widget.session["Комментарий"] ?? "";

    if (comment.isNotEmpty)
      return [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            comment,
            style: TextStyle(
              fontSize: 12,
              color: AppT.c.textSecondary,
              fontStyle: FontStyle.italic,
            )
          )
        )
      ];

    return [];
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
        color: AppT.c.primary,
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
                  ? AppT.c.success
                  : AppT.c.error,
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
      style: TextStyle(fontSize: 16, color: (hasBeenPaid ? AppT.c.success : AppT.c.error)),
    );
  }

  // Стиль оформления основной карточки
  BoxDecoration mainInfoDecoration() {
    return BoxDecoration(
      borderRadius: borderRadius
    );
  }

  // Стиль оформления дополнительной карточки
  BoxDecoration disclosureInfoDecoration() {
    return BoxDecoration(
      color: AppT.c.surface,
      border: Border(top: BorderSide(color: AppT.c.mainActionBackground, width: 1)),
    );
  }

  // Стиль оформления всей карточки сеанса
  BoxDecoration cardDecoration() {
    return BoxDecoration(
      borderRadius: borderRadius,
      color: AppT.c.surface,
      boxShadow: [
        // BoxShadow(
        //   color: AppT.c.textPrimary.withValues(alpha: 0.1),
        //   blurRadius: 12,
        //   offset: const Offset(0, 4),
        //   spreadRadius: 0,
        // ),
        // BoxShadow(
        //   color: AppT.c.textPrimary.withValues(alpha: 0.05),
        //   blurRadius: 4,
        //   offset: const Offset(0, 2),
        //   spreadRadius: 0,
        // ),
      ],
    );
  }
}
