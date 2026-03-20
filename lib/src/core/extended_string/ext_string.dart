
extension StringExtensions on String {
  String pluralForm(int number, String form1, String form2, String form3) {
    if (number % 10 == 1 && number % 100 != 11) return form1;
    if (number % 10 >= 2 && number % 10 <= 4 && (number % 100 < 10 || number % 100 >= 20)) {
      return form2;
    }
    return form3;
  }
}