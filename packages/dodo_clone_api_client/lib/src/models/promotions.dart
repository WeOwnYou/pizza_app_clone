Promotion promotionFromJson(Map<String, dynamic> json) =>
    Promotion.fromJson(json);
Mission missionFromJson(Map<String, dynamic> json) => Mission.fromJson(json);

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

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        expires: json['expires'],
        image: json['image'],
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

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        expires: json['expires'],
        reward: json['dodo_reward'],
        image: json['image'],
      );
}
