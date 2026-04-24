
import 'package:hive/hive.dart';
import 'package:medical_assistant/src/core/directory/directory.dart';

part 'cabinet.g.dart';

@HiveType(typeId: 1)
class Cabinet extends Directory {
  @HiveField(20)
  bool? _isSelected;
  bool get isSelected => _isSelected ?? false;
  set isSelected(bool? value) {
    _isSelected = value ?? false;
  }

  Cabinet({
    required super.id,
    required super.name,
    bool? isSelected,
  }) : _isSelected = isSelected;

  Cabinet.fromMap(Map<String, dynamic> data) : super.fromMap(data) {

  }
}