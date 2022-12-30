import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
    as dodo_clone_api_client;
import 'package:equatable/equatable.dart';

class Story extends Equatable {
  final int id;
  final String name;
  final String frontImage;
  final List<StoryItem> storyItems;
  final bool isWatched;

  static const empty = Story(
    id: -1,
    name: '',
    storyItems: [],
    frontImage: '',
    isWatched: false,
  );

  Story get watched => Story(
        id: id,
        name: name,
        storyItems: storyItems.map((e) => e.copyWith(isWatched: true)).toList(),
        frontImage: '',
        isWatched: false,
      );

  const Story({
    required this.id,
    required this.frontImage,
    required this.name,
    required this.storyItems,
    required this.isWatched,
  });

  factory Story.fromApiClient(dodo_clone_api_client.Story story) {
    return Story(
      id: story.id,
      frontImage: story.frontImage,
      name: story.name,
      storyItems: story.storyItems.map(StoryItem.fromApiClient).toList(),
      isWatched: story.isWatched,
    );
  }

  Story copyWith({
    int? id,
    String? name,
    String? frontImage,
    List<StoryItem>? storyItems,
    bool? isWatched,
  }) {
    return Story(
      id: id ?? this.id,
      name: name ?? this.name,
      frontImage: frontImage ?? this.frontImage,
      storyItems: storyItems ?? this.storyItems,
      isWatched: isWatched ?? this.isWatched,
    );
  }

  @override
  List<Object?> get props => [id, name, isWatched];
}

enum MediaType { image, video, other }

class StoryItem extends Equatable {
  final int id;
  final MediaType contentType;
  final String link;
  final Duration duration;
  final bool isWatched;
  final String? navigationPathApp;
  final String? navigationPathWeb;

  const StoryItem({
    required this.id,
    required this.contentType,
    required this.link,
    required this.duration,
    this.isWatched = false,
    this.navigationPathApp,
    this.navigationPathWeb,
  });

  factory StoryItem.fromApiClient(dodo_clone_api_client.StoryItem item) {
    late final MediaType contentType;
    switch (item.contentType) {
      case 'image':
        contentType = MediaType.image;
        break;
      case 'video':
        contentType = MediaType.video;
        break;
      default:
        contentType = MediaType.other;
    }
    return StoryItem(
      id: item.id,
      contentType: contentType,
      link: item.link,
      duration: item.duration,
    );
  }

  @override
  List<Object?> get props => [id, isWatched];

  StoryItem copyWith({
    int? id,
    MediaType? contentType,
    String? link,
    Duration? duration,
    bool? isWatched,
    String? navigationPathApp,
    String? navigationPathWeb,
  }) {
    return StoryItem(
      id: id ?? this.id,
      contentType: contentType ?? this.contentType,
      link: link ?? this.link,
      duration: duration ?? this.duration,
      isWatched: isWatched ?? this.isWatched,
      navigationPathApp: navigationPathApp ?? this.navigationPathApp,
      navigationPathWeb: navigationPathWeb ?? this.navigationPathWeb,
    );
  }
}
