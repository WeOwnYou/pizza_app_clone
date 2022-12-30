import 'package:equatable/equatable.dart';

class MainState extends Equatable {
  final int shoppingCartLength;

  const MainState({
    this.shoppingCartLength = 0,
  });

  @override
  List<Object?> get props => [shoppingCartLength];

  MainState copyWith({
    int? shoppingCartLength,
  }) {
    return MainState(
      shoppingCartLength: shoppingCartLength ?? this.shoppingCartLength,
    );
  }
}
