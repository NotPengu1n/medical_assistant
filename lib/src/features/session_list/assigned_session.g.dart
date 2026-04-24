// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assigned_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssignedSessionAdapter extends TypeAdapter<AssignedSession> {
  @override
  final int typeId = 2;

  @override
  AssignedSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssignedSession(
      sessionDate: fields[0] as String?,
      timeFrom: fields[1] as String?,
      timeTo: fields[2] as String?,
      isPaid: fields[3] as bool?,
      isUrgent: fields[4] as bool?,
      paymentPercent: fields[5] as int?,
      isPaymentCompleted: fields[6] as bool?,
      completed: fields[7] as int?,
      remaining: fields[8] as int?,
      assigned: fields[9] as dynamic,
      nearestSession: fields[10] as String?,
      comment: fields[11] as String?,
      rowCode: fields[12] as int?,
      documentResult: fields[13] as dynamic,
      places: fields[14] as int?,
      personTimeFrom: fields[15] as dynamic,
      personTimeTo: fields[16] as dynamic,
      executor: fields[17] as dynamic,
      parametersRepresentation: fields[18] as String?,
      isCompleted: fields[19] as bool?,
      personIconNumber: fields[20] as int?,
      labelRepresentation: fields[21] as String?,
      building: fields[22] as String?,
      guestCard: (fields[23] as Map?)?.cast<String, dynamic>(),
      patient: (fields[24] as Map?)?.cast<String, dynamic>(),
      service: (fields[25] as Map?)?.cast<String, dynamic>(),
      assignmentParameters: (fields[26] as Map?)?.cast<String, dynamic>(),
      room: (fields[27] as Map?)?.cast<String, dynamic>(),
      equipment: (fields[28] as Map?)?.cast<String, dynamic>(),
      assignmentDocument: (fields[29] as Map?)?.cast<String, dynamic>(),
      medicalCard: (fields[30] as Map?)?.cast<String, dynamic>(),
      isPassed: fields[31] as bool?,
      isNoShow: fields[32] as bool?,
      id: fields[33] as String,
      date: fields[34] as String?,
      isPaidFlag: fields[35] as bool?,
      temporaryVisibility: fields[36] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, AssignedSession obj) {
    writer
      ..writeByte(37)
      ..writeByte(0)
      ..write(obj.sessionDate)
      ..writeByte(1)
      ..write(obj.timeFrom)
      ..writeByte(2)
      ..write(obj.timeTo)
      ..writeByte(3)
      ..write(obj.isPaid)
      ..writeByte(4)
      ..write(obj.isUrgent)
      ..writeByte(5)
      ..write(obj.paymentPercent)
      ..writeByte(6)
      ..write(obj.isPaymentCompleted)
      ..writeByte(7)
      ..write(obj.completed)
      ..writeByte(8)
      ..write(obj.remaining)
      ..writeByte(9)
      ..write(obj.assigned)
      ..writeByte(10)
      ..write(obj.nearestSession)
      ..writeByte(11)
      ..write(obj.comment)
      ..writeByte(12)
      ..write(obj.rowCode)
      ..writeByte(13)
      ..write(obj.documentResult)
      ..writeByte(14)
      ..write(obj.places)
      ..writeByte(15)
      ..write(obj.personTimeFrom)
      ..writeByte(16)
      ..write(obj.personTimeTo)
      ..writeByte(17)
      ..write(obj.executor)
      ..writeByte(18)
      ..write(obj.parametersRepresentation)
      ..writeByte(19)
      ..write(obj.isCompleted)
      ..writeByte(20)
      ..write(obj.personIconNumber)
      ..writeByte(21)
      ..write(obj.labelRepresentation)
      ..writeByte(22)
      ..write(obj.building)
      ..writeByte(23)
      ..write(obj.guestCard)
      ..writeByte(24)
      ..write(obj.patient)
      ..writeByte(25)
      ..write(obj.service)
      ..writeByte(26)
      ..write(obj.assignmentParameters)
      ..writeByte(27)
      ..write(obj.room)
      ..writeByte(28)
      ..write(obj.equipment)
      ..writeByte(29)
      ..write(obj.assignmentDocument)
      ..writeByte(30)
      ..write(obj.medicalCard)
      ..writeByte(31)
      ..write(obj.isPassed)
      ..writeByte(32)
      ..write(obj.isNoShow)
      ..writeByte(33)
      ..write(obj.id)
      ..writeByte(34)
      ..write(obj.date)
      ..writeByte(35)
      ..write(obj.isPaidFlag)
      ..writeByte(36)
      ..write(obj.temporaryVisibility);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignedSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
