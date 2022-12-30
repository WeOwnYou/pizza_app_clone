import 'package:equatable/equatable.dart';

enum SplashStateStatus { initial, loading, success, failure }

class SplashState extends Equatable {
  final SplashStateStatus status;

  const SplashState({
    required this.status,
  });

  static SplashState initial =
      const SplashState(status: SplashStateStatus.initial);

  @override
  List<Object?> get props => [status];

  SplashState copyWith({
    SplashStateStatus? status,
  }) {
    return SplashState(
      status: status ?? this.status,
    );
  }
}
