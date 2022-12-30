Person personFromJson(Map<String, dynamic> json) => Person.fromJson(json);

class Person {
  final int id;
  final String name;
  final String email;
  final String birthday;
  final int dodoCoins;
  final bool authorized;

  const Person({
    required this.id,
    required this.name,
    required this.email,
    required this.birthday,
    required this.dodoCoins,
    required this.authorized,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['person_id'],
      name: json['name'],
      email: json['email'],
      birthday: json['birthday'],
      dodoCoins: json['dodo_coins'],
      authorized: json['person_id'] != null,
    );
  }
}
