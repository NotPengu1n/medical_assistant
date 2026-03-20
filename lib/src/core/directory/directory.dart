import 'package:hive/hive.dart';

part 'directory.g.dart';  // Добавьте part

@HiveType(typeId: 0)  // Добавьте typeId для базового класса
class Directory {
  @HiveField(0)
  String? id = "";

  @HiveField(1)
  String? name = "";

  Directory({required this.id, required this.name});

  Directory.fromMap(Map<String, dynamic> data) {
    id = data["Идентификатор"];
    name = data["Наименование"];
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is Directory && other.id == id;

  @override
  String toString() {
    return name ?? "";
  }

  // Переводим текущий объект в Map для обмена по API, то есть нужен только идентификатор объекта
  Map<String, dynamic> toApiMap() {
    return {
      "id": id
    };
  }
}