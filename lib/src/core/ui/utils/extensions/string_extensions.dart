import 'package:intl/intl.dart';

extension CustomStringExtension on String {
  String capitalize() {
    if (length == 0) return '';
    if (length == 1) return toUpperCase();
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get stroked {
    final buffer = StringBuffer();
    for (final codeUnit in codeUnits) {
      buffer.write(String.fromCharCodes([822, codeUnit, 822]));
    }
    return buffer.toString();
  }

  List<int> searchContentStartEnd(String searchText) {
    final firstIndex = toLowerCase().indexOf(searchText.toLowerCase());
    if (length == 1) return [firstIndex, firstIndex];
    final lastIndex = toLowerCase().indexOf(
      searchText[searchText.length - 1].toLowerCase(),
      firstIndex + searchText.length - 1,
    );
    return [firstIndex, lastIndex];
  }

  DateTime get stringToDate {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.parse(this);
  }

  String get expireDate {
    final date = stringToDate;
    final res = 'до ${DateFormat('d MMMM').format(date).toLowerCase()}';
    return res;
  }
}
