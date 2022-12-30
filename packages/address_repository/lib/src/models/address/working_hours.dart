part of 'address.dart';

class WorkingHours {
  final String startTime;
  final String endTime;

  const WorkingHours({
    required this.startTime,
    required this.endTime,
  });

  factory WorkingHours.fromApiClient(dodo_clone_api_client.WorkingHours hours) =>
      WorkingHours(startTime: hours.startTime, endTime: hours.endTime);
}
