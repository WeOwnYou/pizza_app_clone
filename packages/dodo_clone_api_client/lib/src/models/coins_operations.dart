CoinsOperationsResponse coinsOperationsFromJson(Map<String, dynamic> str) =>
    CoinsOperationsResponse.fromJson(str);

class CoinsOperationsResponse {
  final bool error;
  final String message;
  final List<CoinsOperation> result;

  const CoinsOperationsResponse({
    required this.error,
    required this.message,
    required this.result,
  });

  factory CoinsOperationsResponse.fromJson(Map<String, dynamic> json) =>
      CoinsOperationsResponse(
        error: json['error'],
        message: json['message'],
        result: List.from(
          (json['result'] as List<Map<String, dynamic>>).map(
            CoinsOperation.fromJson,
          ),
        ),
      );
}

enum OperationType { spend, received }

class CoinsOperation {
  final int id;
  final OperationType type;
  final String title;
  final DateTime dateTime;
  final int coins;

  const CoinsOperation({
    required this.id,
    required this.type,
    required this.title,
    required this.dateTime,
    required this.coins,
  });

  factory CoinsOperation.fromJson(Map<String, dynamic> json) =>
      CoinsOperation(
        id: json['id'],
        type: json['type'] == 'spend'
            ? OperationType.spend
            : OperationType.received,
        title: json['title'],
        dateTime: DateTime.parse(json['date_time']),
        coins: json['coins'],
      );
}
