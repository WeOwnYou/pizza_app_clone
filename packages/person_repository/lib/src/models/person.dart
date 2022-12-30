import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
    as dodo_clone_api_client;

enum AuthType { authorized, unauthorized }

class Person {
  final int id;
  final String name;
  final AuthType authType;
  final int dodoCoins;
  final String? activeChatId;

  const Person({
    required this.id,
    required this.name,
    required this.authType,
    required this.dodoCoins,
    this.activeChatId,
  });

  static Person empty = const Person(
    id: 0,
    name: 'add from hive',
    authType: AuthType.unauthorized,
    dodoCoins: 0,
  );

  bool get isNotEmpty => this != empty;

  factory Person.fromApiClient(dodo_clone_api_client.Person person,
      {String? activeChatId}) {
    return Person(
      id: person.id,
      name: person.name,
      dodoCoins: person.dodoCoins,
      authType: person.authorized ? AuthType.authorized : AuthType.unauthorized,
      activeChatId: activeChatId,
    );
  }

  Person copyWith({String? name, AuthType? authType, int? dodoCoins}) => Person(
        id: id,
        name: name ?? this.name,
        authType: authType ?? this.authType,
        dodoCoins: dodoCoins ?? this.dodoCoins,
      );
}
