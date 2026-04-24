import 'dart:ui';

import 'package:hive/hive.dart';
import 'dart:convert';

import 'package:medical_assistant/src/network/synchronization.dart';

part 'assigned_session.g.dart';

// TODO: тут скорее всего что-то лишнее, но быстро разобраться что сложно.

@HiveType(typeId: 2) // TODO: сохранение
class AssignedSession {
  @HiveField(0)
  String? sessionDate;

  @HiveField(1)
  String? timeFrom;

  @HiveField(2)
  String? timeTo;

  @HiveField(3)
  bool? isPaid;

  @HiveField(4)
  bool? isUrgent;

  @HiveField(5)
  int? paymentPercent;

  @HiveField(6)
  bool? isPaymentCompleted;

  @HiveField(7)
  int? completed;

  @HiveField(8)
  int? remaining;

  @HiveField(9)
  dynamic assigned;

  @HiveField(10)
  String? nearestSession;

  @HiveField(11)
  String? comment;

  @HiveField(12)
  int? rowCode;

  @HiveField(13)
  dynamic documentResult;

  @HiveField(14)
  int? places;

  @HiveField(15)
  dynamic personTimeFrom;

  @HiveField(16)
  dynamic personTimeTo;

  @HiveField(17)
  dynamic executor;

  @HiveField(18)
  String? parametersRepresentation;

  @HiveField(19)
  bool? isCompleted;

  @HiveField(20)
  int? personIconNumber;

  @HiveField(21)
  String? labelRepresentation;

  @HiveField(22)
  String? building;

  @HiveField(23)
  Map<String, dynamic>? guestCard;

  @HiveField(24)
  Map<String, dynamic>? patient;

  @HiveField(25)
  Map<String, dynamic>? service;

  @HiveField(26)
  Map<String, dynamic>? assignmentParameters;

  @HiveField(27)
  Map<String, dynamic>? room;

  @HiveField(28)
  Map<String, dynamic>? equipment;

  @HiveField(29)
  Map<String, dynamic>? assignmentDocument;

  @HiveField(30)
  Map<String, dynamic>? medicalCard;

  @HiveField(31)
  bool? isPassed;

  @HiveField(32)
  bool? isNoShow;

  @HiveField(33)
  String id;

  @HiveField(34)
  String? date;

  @HiveField(35)
  bool? isPaidFlag;

  @HiveField(36)
  bool? temporaryVisibility;

  // TODO: сделать нормально конструктор
  AssignedSession({
    this.sessionDate,
    this.timeFrom,
    this.timeTo,
    this.isPaid,
    this.isUrgent,
    this.paymentPercent,
    this.isPaymentCompleted,
    this.completed,
    this.remaining,
    this.assigned,
    this.nearestSession,
    this.comment,
    this.rowCode,
    this.documentResult,
    this.places,
    this.personTimeFrom,
    this.personTimeTo,
    this.executor,
    this.parametersRepresentation,
    this.isCompleted,
    this.personIconNumber,
    this.labelRepresentation,
    this.building,
    this.guestCard,
    this.patient,
    this.service,
    this.assignmentParameters,
    this.room,
    this.equipment,
    this.assignmentDocument,
    this.medicalCard,
    this.isPassed,
    this.isNoShow,
    required this.id,
    this.date,
    this.isPaidFlag,
    this.temporaryVisibility,
  });

  // Factory constructor to create from Map
  factory AssignedSession.fromMap(Map<String, dynamic> map) {
    return AssignedSession(
      sessionDate: map['ДатаСеанса']?.toString(),
      timeFrom: map['ВремяС']?.toString(),
      timeTo: map['ВремяДо']?.toString(),
      isPaid: map['Платная'],
      isUrgent: map['Срочная'],
      paymentPercent: map['ПроцентОплаты'] is int
          ? map['ПроцентОплаты']
          : (map['ПроцентОплаты'] as num?)?.toInt(),
      isPaymentCompleted: map['фОплачено'],
      completed: map['Пройдено'] is int
          ? map['Пройдено']
          : (map['Пройдено'] as num?)?.toInt(),
      remaining: map['Осталось'] is int
          ? map['Осталось']
          : (map['Осталось'] as num?)?.toInt(),
      assigned: map['Назначено'],
      nearestSession: map['БлижайшийСеанс']?.toString(),
      comment: map['Комментарий']?.toString(),
      rowCode: map['КодСтроки'] is int
          ? map['КодСтроки']
          : (map['КодСтроки'] as num?)?.toInt(),
      documentResult: map['ДокументРезультат'],
      places: map['Мест'] is int
          ? map['Мест']
          : (map['Мест'] as num?)?.toInt(),
      personTimeFrom: map['ФизлицоВремяС'],
      personTimeTo: map['ФизлицоВремяДо'],
      executor: map['Исполнитель'],
      parametersRepresentation: map['ПредставлениеПараметровНазначения']?.toString(),
      isCompleted: map['фПройден'],
      personIconNumber: map['НомерИконкиФизлица'] is int
          ? map['НомерИконкиФизлица']
          : (map['НомерИконкиФизлица'] as num?)?.toInt(),
      labelRepresentation: map['ПредставлениеМетки']?.toString(),
      building: map['Корпус']?.toString(),
      guestCard: map['КартаГостя'] is Map ? Map<String, dynamic>.from(map['КартаГостя']) : null,
      patient: map['Пациент'] is Map ? Map<String, dynamic>.from(map['Пациент']) : null,
      service: map['Услуга'] is Map ? Map<String, dynamic>.from(map['Услуга']) : null,
      assignmentParameters: map['ПараметрыНазначения'] is Map
          ? Map<String, dynamic>.from(map['ПараметрыНазначения'])
          : null,
      room: map['Кабинет'] is Map ? Map<String, dynamic>.from(map['Кабинет']) : null,
      equipment: map['Оборудование'] is Map ? Map<String, dynamic>.from(map['Оборудование']) : null,
      assignmentDocument: map['ДокументНазначения'] is Map
          ? Map<String, dynamic>.from(map['ДокументНазначения'])
          : null,
      medicalCard: map['МедицинскаяКарта'] is Map
          ? Map<String, dynamic>.from(map['МедицинскаяКарта'])
          : null,
      isPassed: map['isPassed'],
      isNoShow: map['isNoShow'],
      id: map['id']?.toString() ?? "",
      date: map['Дата']?.toString(),
      isPaidFlag: map['фПлатная'],
      temporaryVisibility: map['ВременнаяВидимость'],
    );
  }

  // Convert to Map (built-in method)
  Map<String, dynamic> toMap() {
    return {
      'ДатаСеанса': sessionDate,
      'ВремяС': timeFrom,
      'ВремяДо': timeTo,
      'Платная': isPaid,
      'Срочная': isUrgent,
      'ПроцентОплаты': paymentPercent,
      'фОплачено': isPaymentCompleted,
      'Пройдено': completed,
      'Осталось': remaining,
      'Назначено': assigned,
      'БлижайшийСеанс': nearestSession,
      'Комментарий': comment,
      'КодСтроки': rowCode,
      'ДокументРезультат': documentResult,
      'Мест': places,
      'ФизлицоВремяС': personTimeFrom,
      'ФизлицоВремяДо': personTimeTo,
      'Исполнитель': executor,
      'ПредставлениеПараметровНазначения': parametersRepresentation,
      'фПройден': isCompleted,
      'НомерИконкиФизлица': personIconNumber,
      'ПредставлениеМетки': labelRepresentation,
      'Корпус': building,
      'КартаГостя': guestCard,
      'Пациент': patient,
      'Услуга': service,
      'ПараметрыНазначения': assignmentParameters,
      'Кабинет': room,
      'Оборудование': equipment,
      'ДокументНазначения': assignmentDocument,
      'МедицинскаяКарта': medicalCard,
      'isPassed': isPassed,
      'isNoShow': isNoShow,
      'id': id,
      'Дата': date,
      'фПлатная': isPaidFlag,
      'ВременнаяВидимость': temporaryVisibility,
    };
  }

  // Convert to JSON string
  String toJson() {
    return jsonEncode(toMap());
  }

  // Create from JSON string
  static AssignedSession fromJson(String json) {
    return AssignedSession.fromMap(jsonDecode(json));
  }

  Future<bool> handleSessionAction({required bool isCancel, required VoidCallback updateState}) async {
    // Не нужно повторно выполнять отметку
    if (isPassed == true || isNoShow == true) return true;

    temporaryVisibility = false;
    if (!isCancel) {
      completed = 1;
      isPassed = true;
    }
    else {
      isNoShow = true;
      remaining = 0;
    }
    updateState();

    final bool result = await Synchronization.markSession(toMap(), isCancel, false);

    if (result) {

    }
    else { // При ошибке восстанавливаем свойства
      if (!isCancel) {
        completed = 0;
        isPassed = false;
      }
      else {
        isNoShow = false;
        remaining = 1;
      }
    }

    temporaryVisibility = true; // Возвращаем флаг назад, т.к. флаг временный. После этого видимость определяется другими параметрами

    return result;
  }

  @override
  String toString() {
    return 'AssignedSession(${toMap()})';
  }
}