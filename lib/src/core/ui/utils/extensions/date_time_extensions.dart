import 'package:address_repository/address_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension FormattedDate on DateTime {
  String get deliveryFormattedDate {
    return '$dayMonthYearFormatг. '
        'в $hoursMinutesFormat';
  }

  String get hoursMinutesFormat {
    return '${(hour ~/ 10) == 0 ? '0$hour' : hour}:'
        '${(minute ~/ 10) == 0 ? '0$minute' : minute}';
  }

  String get dayMonthYearFormat {
    return '$day ${monthNames[month - 1]} $year';
  }

  String get ddmmyyyyFormat {
    return '${day ~/ 10 == 0 ? '0$day' : day}.'
        '${month ~/ 10 == 0 ? '0$month' : month}.$year';
  }

  String get bonusHistoryFormat {
    return '$day ${monthNames[month - 1]}${year == DateTime.now().year ? '' : ' $year'},'
        ' ${hour < 10 ? '0$hour' : hour}:${minute < 10 ? '0$minute' : minute}';
  }
}

extension FormattedTimeOfADay on TimeOfDay {
  double get toDouble => hour + minute / 60;
}

extension FormatterWorkingHours on WorkingHours {
  String get openInfo {
    final now = TimeOfDay.now();
    final formatter = DateFormat('H:m');
    final startWorkingTime = TimeOfDay.fromDateTime(formatter.parse(startTime));
    final endWorkingTime = TimeOfDay.fromDateTime(formatter.parse(endTime));
    if (now.toDouble < startWorkingTime.toDouble) {
      return 'Откроется в $startTime';
    } else if (now.toDouble > endWorkingTime.toDouble) {
      return 'Откроется завтра в $startTime';
    } else {
      return 'Открыто до $endTime';
    }
  }

  String get formatted {
    final formatter = DateFormat('H:m');
    final startWorkingTime = TimeOfDay.fromDateTime(formatter.parse(startTime));
    final endWorkingTime = TimeOfDay.fromDateTime(formatter.parse(endTime));
    return '${startWorkingTime.hour}:${startWorkingTime.minute} - ${endWorkingTime.hour}: ежедневно';
  }
}

const monthNames = [
  'января',
  'февраля',
  'марта',
  'апреля',
  'мая',
  'июня',
  'июля',
  'августа',
  'сентября',
  'октября',
  'ноября',
  'декабря',
];
