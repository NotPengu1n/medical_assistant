
import 'package:medical_assistant/src/core/directory/directory.dart';

class Service extends Directory {
  Service({
    required super.id,
    required super.name,
  });

  Service.fromMap(Map<String, dynamic> data) : super.fromMap(data) {

  }
}