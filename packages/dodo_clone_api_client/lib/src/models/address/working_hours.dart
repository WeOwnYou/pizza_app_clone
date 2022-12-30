part of 'address.dart';

class WorkingHours {
  final String startTime;
  final String endTime;

  const WorkingHours({
    required this.startTime,
    required this.endTime,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) =>
      WorkingHours(startTime: json['start_time'], endTime: json['end_time']);
}