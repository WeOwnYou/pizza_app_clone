import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

enum StoryStateStatus { initial, success, failure } //inactive, active, paused }

@immutable
class StoryState extends Equatable {
  final StoryStateStatus status;
  final List<Story> stories;
  final int storyActiveIndex;
  final List<int> storyItemsActiveIndexes;
  // final int storyItemActiveIndex;

  Story get currentStory => stories[storyActiveIndex];
  StoryItem get currentStoryItem =>
      currentStory.storyItems[storyItemsActiveIndexes[storyActiveIndex]];
  int get storyItemActiveIndex => storyItemsActiveIndexes[storyActiveIndex];

  const StoryState({
    required this.status,
    required this.stories,
    required this.storyActiveIndex,
    required this.storyItemsActiveIndexes,
    // required this.storyItemActiveIndex,
  });

  static const empty = StoryState(
    status: StoryStateStatus.initial,
    stories: [],
    storyActiveIndex: 0,
    storyItemsActiveIndexes: [],
    // storyItemActiveIndex: 0,
  );

  @override
  List<Object?> get props => [
        status, stories, storyActiveIndex, storyItemsActiveIndexes,
        // storyItemActiveIndex,
      ];

  StoryState copyWith({
    StoryStateStatus? status,
    List<Story>? stories,
    int? storyActiveIndex,
    // int? storyItemActiveIndex,
    Set<int>? watchedStoryIDs,
    List<int>? storyItemsActiveIndexes,
  }) {
    return StoryState(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      storyActiveIndex: storyActiveIndex ?? this.storyActiveIndex,
      storyItemsActiveIndexes:
          storyItemsActiveIndexes ?? this.storyItemsActiveIndexes,
      // storyItemActiveIndex: storyItemActiveIndex ?? this.storyItemActiveIndex,
    );
  }
}
