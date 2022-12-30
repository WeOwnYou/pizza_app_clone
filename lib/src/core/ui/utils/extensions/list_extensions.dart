extension CustomIntListExtension on List<int> {
  num sumPartOfList(int end) {
    var result = 0.0;
    for (var i = 0; i < end; i++) {
      result += this[i];
    }
    return result;
  }
}
