// import 'package:equatable/equatable.dart';
// import 'package:person_repository/person_repository.dart' as person_repository;
// import 'package:person_repository/person_repository.dart';
//
// class Person extends Equatable {
//   final int id;
//   final String name;
//   final String city;
//   final int? dodoCoins;
//   final OrdersHistory ordersHistory;
//
//   const Person({
//     required this.id,
//     required this.name,
//     required this.city,
//     this.dodoCoins,
//     required this.ordersHistory,
//   });
//
//   static Person empty = const Person(
//       name: 'add from hive',
//       city: '',
//       ordersHistory: OrdersHistory(personId: 0, orders: []),
//       id: 0,);
//
//   factory Person.fromRepository(
//     person_repository.Person person,
//     person_repository.OrdersHistory ordersHistory,
//   ) =>
//       Person(
//         id: person.id,
//         name: person.name,
//         city: person.,
//         dodoCoins: person.dodoCoins,
//         ordersHistory: ordersHistory,
//       );
//
//   @override
//   List<Object?> get props => [name, dodoCoins];
// }
