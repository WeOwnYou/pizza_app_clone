import 'package:dodo_clone_api_client/dodo_clone_api_client.dart' as dodo_clone_api_client;

Promotion promotionFromApiClient(dodo_clone_api_client.Promotion promotion) =>
    Promotion.fromApiClient(promotion);
Mission missionFromApiClient(dodo_clone_api_client.Mission mission) =>
    Mission.fromApiClient(mission);

class Promotion {
  final int id;
  final String title;
  final String description;
  final String? image;
  final String expires;

  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.expires,
  });

  factory Promotion.fromApiClient(dodo_clone_api_client.Promotion promotion) => Promotion(
    id: promotion.id,
    title: promotion.title,
    description: promotion.description,
    expires: promotion.expires,
    image: promotion.image,
  );
}

class Mission {
  final int id;
  final String title;
  final String description;
  final String? image;
  final String expires;
  final int? reward;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.expires,
    this.reward,
  });

  factory Mission.fromApiClient(dodo_clone_api_client.Mission mission) => Mission(
    id: mission.id,
    title: mission.title,
    description: mission.description,
    expires: mission.expires,
    reward: mission.reward,
    image: mission.image,
  );
}
