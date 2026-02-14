class KintApiException implements Exception {
  final int code;
  String? error;

  KintApiException({required this.code, this.error});

  @override
  String toString() {
    return error.toString();
  }
}