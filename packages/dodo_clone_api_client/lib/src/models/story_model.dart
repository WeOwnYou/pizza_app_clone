Stories storiesFromJson(Map<String, dynamic> str) => Stories.fromJson(str);

class Stories {
  final bool error;
  final String message;
  final List<Story> result;

  const Stories({
    required this.error,
    required this.message,
    required this.result,
  });

  factory Stories.fromJson(Map<String, dynamic> json) => Stories(
      error: json['error'],
      message: json['message'],
      result: List<Story>.from(
        (json['result'] as List<Map<String, dynamic>>)
            .map((Story.fromJson))
            .toList(),
      ));
}

class Story {
  final int id;
  final String name;
  final String? badge;
  final String frontImage;
  final List<StoryItem> storyItems;
  final bool isWatched;

  const Story({
    required this.id,
    required this.name,
    this.badge,
    required this.frontImage,
    required this.isWatched,
    required this.storyItems,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        id: json['id'] as int,
        name: json['story_name'],
        badge: json['badge'],
        frontImage: json['front_image'],
        isWatched: json['watched'],
        storyItems: (json['story_content'] as List<Map<String, dynamic>>)
            .map(StoryItem.fromJson)
            .toList(),
      );
}

class StoryItem {
  final int id;
  final String contentType;
  final String link;
  final Duration duration;
  final String? navigationPathApp;
  final String? navigationPathWeb;

  StoryItem({
    required this.id,
    required this.contentType,
    required this.link,
    required int? duration,
    this.navigationPathApp,
    this.navigationPathWeb,
  }) : duration = (duration == null)
            ? const Duration(seconds: 5)
            : Duration(seconds: duration);

  factory StoryItem.fromJson(Map<String, dynamic> json) {
    return StoryItem(
      id: json['id'],
      contentType: json['content_type'] as String,
      link: json['link'] as String,
      duration: int.tryParse((json['duration'] as String?) ?? ''),
      navigationPathApp: json['navigate_in_app'] as String?,
      navigationPathWeb: json['navigate_to_web'] as String?,
    );
  }
}
