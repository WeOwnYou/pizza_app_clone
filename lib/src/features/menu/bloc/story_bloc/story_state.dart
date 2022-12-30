import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// States:
/// 1. initial (with initialIndex)
/// 2. loading (while image (or other content) loading)
/// 3. successful (has data)
/// 4. failure (if anything goes wrong)

abstract class StoryState extends Equatable {
  const StoryState();
}

class StoryStateInitial extends StoryState {
  final int storyActiveIndex;

  @override
  List<Object?> get props => [storyActiveIndex];

  const StoryStateInitial({
    required this.storyActiveIndex,
  });
}

class StoryStateSuccess extends StoryState {
  final int storyActiveIndex;
  final List<Story> stories;
  final List<int> storyItemsActiveIndexes;

  @override
  List<Object?> get props => [
        storyActiveIndex,
        stories,
        storyItemsActiveIndexes,
      ];

  Story get currentStory => stories[storyActiveIndex];
  StoryItem get currentStoryItem =>
      currentStory.storyItems[storyItemsActiveIndexes[storyActiveIndex]];
  int get storyItemActiveIndex => storyItemsActiveIndexes[storyActiveIndex];

  const StoryStateSuccess({
    required this.storyActiveIndex,
    required this.stories,
    required this.storyItemsActiveIndexes,
  });
}

class StoryStateFailure extends StoryState {
  final String message;

  @override
  List<Object?> get props => [message];

  const StoryStateFailure({
    required this.message,
  });
}

enum StoryStateStatus { initial, success, failure }

@immutable
class StoryStateOld extends Equatable {
  final StoryStateStatus status;
  final List<Story> stories;
  final int storyActiveIndex;
  final List<int> storyItemsActiveIndexes;

  Story get currentStory => stories[storyActiveIndex];
  StoryItem get currentStoryItem =>
      currentStory.storyItems[storyItemsActiveIndexes[storyActiveIndex]];
  int get storyItemActiveIndex => storyItemsActiveIndexes[storyActiveIndex];

  const StoryStateOld({
    required this.status,
    required this.stories,
    required this.storyActiveIndex,
    required this.storyItemsActiveIndexes,
  });

  factory StoryStateOld.initial(int index) => StoryStateOld(
        status: StoryStateStatus.initial,
        stories: List.empty(),
        storyActiveIndex: index,
        storyItemsActiveIndexes: List.empty(),
      );

  @override
  List<Object?> get props => [
        status,
        stories,
        storyActiveIndex,
        storyItemsActiveIndexes,
      ];

  StoryStateOld copyWith({
    StoryStateStatus? status,
    List<Story>? stories,
    int? storyActiveIndex,
    List<int>? storyItemsActiveIndexes,
    Set<int>? watchedStoryIDs,
  }) {
    return StoryStateOld(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      storyActiveIndex: storyActiveIndex ?? this.storyActiveIndex,
      storyItemsActiveIndexes:
          storyItemsActiveIndexes ?? this.storyItemsActiveIndexes,
    );
  }
}
