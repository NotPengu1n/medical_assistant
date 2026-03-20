
import 'package:hive/hive.dart';
import 'package:medical_assistant/src/features/cabinets/cabinet.dart';
import 'package:medical_assistant/src/network/synchronization.dart';

// TODO: Нужен отдельный родительский класс для справочников. Функциональных справочников сейчас в принципе мало, так что пока неактуально.
class CabinetsData {
  static const String name = "Cabinets";
  static late Box<Cabinet> cabinetsBox;

  // Обязательная регистрация хранилища при запуске
  static Future<void> register() async {
    try {
      Hive.registerAdapter(CabinetAdapter());
      await Hive.openBox<Cabinet>(name);
      cabinetsBox = Hive.box<Cabinet>(name);
    }
    catch (error) {
      print('Ошибка: $error');
    }
  }

  // Сохранение кабинета
  static Future<void> save(Cabinet cabinet) async {
    await cabinetsBox.put(cabinet.id, cabinet);
  }

  // Сохранение кабинетов из списка Map
  static Future<void> saveFromListMap(List<Map<String, dynamic>> cabinets) async {
    for (var cabinetMap in cabinets) {
      Cabinet cabinet = Cabinet.fromMap(cabinetMap);
      cabinet.isSelected = cabinetsBox.get(cabinet.id)?.isSelected; // Подгружаем флаг выбранности. Возможно, в справочнике хранить этот флаг неправильно (так и есть).
      save(cabinet);
    }
  }

  // Получить список кабинетов
  static List<Cabinet> getCabinets({bool? isSelected}) {
    if (isSelected == null)
      return cabinetsBox.values.toList();
    else
      return cabinetsBox.values.where((cabinet) => cabinet.isSelected).toList();
  }

  // Получаем список кабинетов для формы выбора кабинетов
  static Future<List<Cabinet>> getCabinetsToChoose() async {
    await Synchronization.getCabinets();
    return await getCabinets();
  }

  // Проверяем есть ли хотя бы один выбранный кабинет
  static bool hasSelected() {
    return cabinetsBox.values.any((cabinet) => cabinet.isSelected);
  }
}