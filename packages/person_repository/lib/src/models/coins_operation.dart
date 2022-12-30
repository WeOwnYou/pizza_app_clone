import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
    as dodo_clone_api_client;

CoinsOperation coinsOperationFromApiClient(
        dodo_clone_api_client.CoinsOperation coinsOperation) =>
    CoinsOperation.fromApiClient(coinsOperation);

enum OperationType { spend, received }

extension IsType on OperationType {
  bool get isSpend => this == OperationType.spend;
  bool get isReceived => this == OperationType.received;
}

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

  factory CoinsOperation.fromApiClient(
      dodo_clone_api_client.CoinsOperation coinsOperation) {
    late OperationType operationType;
    switch (coinsOperation.type) {
      case dodo_clone_api_client.OperationType.spend:
        operationType = OperationType.spend;
        break;
      case dodo_clone_api_client.OperationType.received:
        operationType = OperationType.received;
        break;
    }
    return CoinsOperation(
      id: coinsOperation.id,
      type: operationType,
      title: coinsOperation.title,
      dateTime: coinsOperation.dateTime,
      coins: coinsOperation.coins,
    );
  }
}
