part of 'menu_view.dart';

class _BuildCategoriesBlock extends StatelessWidget {
  final ScrollController categoryController;
  final List<GlobalKey> sectionKeys;
  final void Function(int) onCategoryTap;
  const _BuildCategoriesBlock({
    required this.categoryController,
    required this.sectionKeys,
    required this.onCategoryTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate:
          _BuildCustomDelegate(sectionKeys, categoryController, onCategoryTap),
      // child:
    );
  }
}

class _BuildCustomDelegate extends SliverPersistentHeaderDelegate {
  final ScrollController categoryController;
  final List<GlobalKey> sectionKeys;
  final void Function(int) onCategoryTap;
  const _BuildCustomDelegate(
    this.sectionKeys,
    this.categoryController,
    this.onCategoryTap,
  );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: !overlapsContent ? [] : kElevationToShadow[1],
      ),
      child: BlocBuilder<MenuBloc, MenuState>(
        buildWhen: (oldState, state) {
          return oldState.sections.length != state.sections.length ||
              oldState.sectionCurrentIndex != state.sectionCurrentIndex;
        },
        builder: (blocContext, state) {
          return ListView.builder(
            controller: categoryController,
            padding: const EdgeInsets.symmetric(
              horizontal: kMainHorizontalPadding,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: state.sections.length,
            itemBuilder: (ctx, index) {
              final category = state.sections[index].name;
              return Padding(
                key: sectionKeys[index],
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: GestureDetector(
                  onTap: () {
                    onCategoryTap(index);
                    context.read<MenuBloc>().add(
                          MenuCategoryChangedEvent(index, manualControl: true),
                        );
                  },
                  child: Chip(
                    key: ValueKey(index),
                    labelStyle: TextStyle(
                      color: index == state.sectionCurrentIndex
                          ? AppColors.mainTextOrange
                          : AppColors.mainIconGrey,
                    ),
                    label: Text(category),
                    backgroundColor: index == state.sectionCurrentIndex
                        ? AppColors.secondBgOrange
                        : AppColors.mainBgGrey,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
