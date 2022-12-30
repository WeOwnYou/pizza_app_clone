part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileLoadEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class RepeatOrderEvent extends ProfileEvent {
  final int orderId;
  const RepeatOrderEvent(this.orderId);
  @override
  List<Object?> get props => [orderId];
}

class DeleteAccountEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class UpdateCoinsNumberEvent extends ProfileEvent {
  final int? availableCoins; //коины в работе
  final int? actualCoins; //количество непотраченных коинов
  const UpdateCoinsNumberEvent({this.availableCoins, this.actualCoins})
      : assert((availableCoins != null) ^ (actualCoins != null),
            'U should update at least one parameter',);
  @override
  List<Object?> get props => [
        availableCoins,
        actualCoins,
      ];
}
