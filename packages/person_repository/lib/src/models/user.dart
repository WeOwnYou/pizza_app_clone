// class User {
//   final String idUser;
//   final String name;
//   final int activeChatId;
//   final DateTime? lastMessageTime;
//
//
//   const User({
//     required this.idUser,
//     required this.name,
//     required this.activeChatId,
//     this.lastMessageTime,
//   });
//
//   @override
//   String toString() {
//     return 'User{ idUser: $idUser, name: $name, lastMessageTime: $lastMessageTime,}';
//   }
//
//   User copyWith({
//     String? idUser,
//     String? name,
//     DateTime? lastMessageTime,
//     int? activeChatId,
//   }) {
//     return User(
//       idUser: idUser ?? this.idUser,
//       name: name ?? this.name,
//       lastMessageTime: lastMessageTime ?? this.lastMessageTime,
//       activeChatId: activeChatId ?? this.activeChatId,
//     );
//   }
//
//   factory User.fromJson(Map<String, dynamic> json, String userId) {
//     return User(
//       idUser: userId,
//       name: json['name'] as String,
//       activeChatId: json['activeChat'] as int,
//       // lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
//     );
//   }
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'idUser': idUser,
//         'name': name,
//         'lastMessageTime': lastMessageTime.toString(),
//       };
// }
