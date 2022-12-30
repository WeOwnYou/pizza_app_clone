part of 'menu_view.dart';

class _StoriesBlock extends StatelessWidget {
  const _StoriesBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      buildWhen: (prev, next) {
        return prev.stories != next.stories;
      },
      builder: (context, state) => SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height *
              MenuConstants.storyFromHeight,
          child: ListView.builder(
            padding: const EdgeInsets.all(kMainHorizontalPadding),
            itemCount: state.stories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  AppRouter.instance()
                      .push(
                    StoryRoute(
                      initialStoryIndex: index,
                    ),
                  )
                      .then((value) {
                    if (value != null && (value as List<int>).isNotEmpty) {
                      context
                          .read<MenuBloc>()
                          .add(MenuStoryWatchedEvent(value));
                    }
                  });
                },
                child: AspectRatio(
                  aspectRatio: 0.8,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                    padding: state.stories[index].isWatched
                        ? null
                        : const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kMainBorderRadius),
                      border: state.stories[index].isWatched
                          ? null
                          : Border.all(
                              width: 2,
                              color: AppColors.mainBgOrange,
                            ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        kMainBorderRadius - 3,
                      ),
                      child: ProductImageWidget(
                        url: state.stories[index].frontImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
