part of 'profile_bloc.dart';

enum ProfileStateStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStateStatus status;
  final Person person;
  final List<Promotion> promotions;
  final List<Mission> missions;
  final OrdersHistory ordersHistory;

  const ProfileState({
    required this.status,
    required this.person,
    this.promotions = const [],
    this.missions = const [],
    required this.ordersHistory,
  });

  static ProfileState empty = ProfileState(
      status: ProfileStateStatus.initial,
      person: Person.empty,
      ordersHistory: OrdersHistory.empty,);

  @override
  List<Object?> get props => [status, person];

  ProfileState copyWith({
    ProfileStateStatus? status,
    Person? person,
    List<Promotion>? promotions,
    List<Mission>? missions,
    OrdersHistory? ordersHistory,
  }) {
    return ProfileState(
      status: status ?? this.status,
      person: person ?? this.person,
      promotions: promotions ?? this.promotions,
      missions: missions ?? this.missions,
      ordersHistory: ordersHistory ?? this.ordersHistory,
    );
  }
}
