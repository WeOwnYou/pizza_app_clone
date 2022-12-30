extension CustomIntExtension on int {
  String declension(String one, String two, String five) {
    var n = this % 100;
    if (n >= 5 && n <= 20) {
      return five;
    }
    n %= 10;
    if (n == 1) {
      return one;
    }
    if (n >= 2 && n <= 4) {
      return two;
    }
    return five;
  }

  String get rubles => '$this ₽';

  String get coins => '${this} D';
}
