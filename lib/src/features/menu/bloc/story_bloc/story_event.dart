abstract class StoryEvent {
  const StoryEvent();
}

class StoryInitialEvent extends StoryEvent {
  final int initialStoryIndex;

  const StoryInitialEvent(this.initialStoryIndex);
}

class StoryChangeEvent extends StoryEvent {
  final int? storyIndex;
  final int? storyItemIndex;

  const StoryChangeEvent({this.storyIndex, this.storyItemIndex});
}

class StoryCloseEvent extends StoryEvent {}
