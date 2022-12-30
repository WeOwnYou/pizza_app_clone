import 'package:equatable/equatable.dart';
import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
    as dodo_clone_api_client;

Section sectionFromApiClient(dodo_clone_api_client.Section section) => Section.fromApiClient(section);

class Section extends Equatable {
  final int id;
  final String name;

  const Section({required this.id, required this.name});

  factory Section.fromApiClient(dodo_clone_api_client.Section section) {
    return Section(
      id: section.id,
      name: section.categoryName,
    );
  }

  @override
  List<Object?> get props => [id];
}
