import 'package:dodo_clone_api_client/dodo_clone_api_client.dart' as dodo_clone_api_client;
import 'package:equatable/equatable.dart';

City cityFromApiClient(dodo_clone_api_client.City city) => City.fromApiClient(city);

class City extends Equatable {
  final int id;
  final String name;
  final int offset;

  const City({
    required this.id,
    required this.name,
    required this.offset,
  });

  factory City.fromApiClient(dodo_clone_api_client.City city) => City(
    id: int.parse(city.id),
    name: city.name,
    // TODO(fix): fix DB table!!!
    offset: 0,
  );

  @override
  List<Object?> get props => [id, name];
}
