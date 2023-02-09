import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/features/menu/bloc/story_bloc/story_event.dart';
import 'package:dodo_clone/src/features/menu/bloc/story_bloc/story_state.dart';
import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final IDodoCloneRepository _pizzaRepository;

  StoryBloc(this._pizzaRepository, int initialStoryIndex)
      : super(StoryState.empty.copyWith(storyActiveIndex: initialStoryIndex)) {
    on<StoryInitialEvent>(_initialize);
    on<StoryChangeEvent>(_storyChange);
    on<StoryCloseEvent>(_closeStory);
    add(StoryInitialEvent(initialStoryIndex));
  }

  Future<void> _initialize(
    StoryInitialEvent event,
    Emitter<StoryState> emit,
  ) async {
    final storyData = _pizzaRepository.cachedStories;
    Set<int>? initialWatchedIDs;
    for (var i = 0; i < storyData.length; i++) {
      if (storyData[i].isWatched) {
        initialWatchedIDs = <int>{}..add(storyData[i].id);
      }
    }
    emit(
      state.copyWith(
        storyActiveIndex: event.initialStoryIndex,
        watchedStoryIDs: initialWatchedIDs,
        status: StoryStateStatus.success,
        stories: storyData,
        storyItemsActiveIndexes: List.generate(storyData.length, (index) => 0),
      ),
    );
  }

  void _storyChange(
    StoryChangeEvent event,
    Emitter<StoryState> emit,
  ) {
    assert(
      (event.storyIndex == null) ^ (event.storyItemIndex == null),
      'Should be provided 1 argument at least',
    );
    Story? updatedStory;

    /// Пометить [Story] как просмотренную
    if ((event.storyIndex != null &&
            event.storyIndex! > state.storyActiveIndex) ||
        event.storyItemIndex == state.currentStory.storyItems.length - 1) {
      updatedStory = state.currentStory.copyWith(
        isWatched: true,
      );
    }

    /// Пометить [StoryItem] как просмотренный
    if (event.storyItemIndex != null) {
      final updatedStoryItems = List<StoryItem>.from(state.currentStory.storyItems);
      updatedStoryItems[event.storyItemIndex!] = updatedStoryItems[event.storyItemIndex!].copyWith(isWatched: true);
      updatedStory = (updatedStory ?? state.currentStory).copyWith(storyItems: updatedStoryItems);
          // state
          // .currentStory.storyItems[max(0, event.storyItemIndex! - 1)]
          // .copyWith(
        // isWatched: true,
      // );
      // updatedStory = (updatedStory ?? state.currentStory).copyWith(
      //   storyItems: updatedStoryItems,
      // );
      state.storyItemsActiveIndexes[state.storyActiveIndex] =
          event.storyItemIndex!;
    }
    emit(
      state.copyWith(
        storyItemsActiveIndexes: state.storyItemsActiveIndexes,
        storyActiveIndex: event.storyIndex,
        stories: state.stories.map<Story>((e) {
          return e.id == updatedStory?.id ? updatedStory! : e;
        }).toList(),
      ),
    );
  }

  void _closeStory(
    StoryCloseEvent event,
    Emitter<StoryState> emit,
  ) {
    AppRouter.instance().pop(
      state.stories
          .where((element) => element.storyItems.last.isWatched)
          .map((e) => e.id)
          .toList(),
    );
  }
}
