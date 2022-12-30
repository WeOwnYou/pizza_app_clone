import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_sizes.dart';
import 'package:dodo_clone/src/core/ui/widgets/dodo_text_button.dart';
import 'package:dodo_clone/src/features/location/bloc/select_city_cubit/select_city_cubit.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_cubit.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _selectedCountry = 'Россия';

class SelectCityModalSheet extends StatefulWidget {
  final BuildContext parentContext;
  const SelectCityModalSheet({required this.parentContext, Key? key})
      : super(key: key);

  @override
  State<SelectCityModalSheet> createState() => _SelectCityModalSheetState();
}

class _SelectCityModalSheetState extends State<SelectCityModalSheet> {
  late final DraggableScrollableController _controller;
  bool needToPop = false;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController()
      ..addListener(() {
        {
          if (_controller.size < 0.3 &&
              Navigator.of(context).canPop() &&
              !needToPop) {
            needToPop = true;
            Navigator.of(context).pop();
          }
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.95,
      maxChildSize: 0.95,
      snap: true,
      builder: (ctx, controller) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SelectCityView(
          parentContext: widget.parentContext,
          controller: controller,
        ),
      ),
    );
  }
}

/// MAIN SELECT CITY SCREEN!!!

class SelectCityView extends StatefulWidget with AutoRouteWrapper {
  final BuildContext? parentContext;
  final ScrollController _scrollController;

  SelectCityView({
    this.parentContext,
    ScrollController? controller,
    Key? key,
  })  : _scrollController = controller ?? ScrollController(),
        super(key: key);

  @override
  State<SelectCityView> createState() => _SelectCityViewState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectCityCubit(),
      child: this,
    );
  }
}

class _SelectCityViewState extends State<SelectCityView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _expandController;
  late final Animation<double> _animation;
  late final Animation<double> _secondAnimation;
  late final FocusNode _focusNode;

  bool get fullScreen => widget.parentContext == null;

  @override
  void initState() {
    super.initState();
    widget._scrollController.addListener(() {
      setState(() {});
    });
    _focusNode = FocusNode()
      ..addListener(() {
        setState(_runExpandCheck);
      });
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.fastOutSlowIn,
    );
    _secondAnimation = ReverseAnimation(
      _animation,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (fullScreen) {
      widget._scrollController.dispose();
    }
    _expandController.dispose();
    super.dispose();
  }

  void _runExpandCheck() {
    if (_focusNode.hasFocus) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state.cities.isEmpty) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return CustomScrollView(
            controller: widget._scrollController,
            slivers: [
              _BuildAppBarWidget(
                fullScreen: fullScreen,
                controller: widget._scrollController,
                animation: _secondAnimation,
              ),
              SliverToBoxAdapter(
                child: SizeTransition(
                  axisAlignment: -1.0,
                  sizeFactor: _secondAnimation,
                  child: const Padding(
                    padding: EdgeInsets.only(
                      left: kMainHorizontalPadding,
                      top: kMainHorizontalPadding,
                    ),
                    child: Text(
                      _selectedCountry,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
              ),
              _BuildSearchWidget(
                focusNode: _focusNode,
                animation: _animation,
              ),
              _BuildCitiesListWidget(
                fullScreen: fullScreen,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BuildAppBarWidget extends StatelessWidget {
  final bool fullScreen;
  final ScrollController controller;
  final Animation<double> animation;
  const _BuildAppBarWidget({
    required this.fullScreen,
    required this.controller,
    required this.animation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      pinned: true,
      titleTextStyle: const SliverAppBar().titleTextStyle?.copyWith(
            fontWeight: FontWeight.w400,
          ),
      title: Column(
        children: [
          const SizedBox(height: 15),
          const Text(
            'Выберите город, чтобы посмотреть меню',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizeTransition(
            axisAlignment: -1.0,
            sizeFactor: animation,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.adaptive.arrow_back,
                          color: AppColors.mainTextOrange,
                        ),
                        const Text(
                          'Страны',
                          style: TextStyle(
                            color: AppColors.mainTextOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: controller.hasClients &&
                          controller.offset > 28 + kMainHorizontalPadding
                      ? const Text(
                          _selectedCountry,
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: fullScreen
                      ? const SizedBox.shrink()
                      : buildCancelButton(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildCancelButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: DodoTextButton(
          text: 'Отменить',
          onTap: () {
            AppRouter.instance().popTop();
          },
        ),
      ),
    );
  }
}

class _BuildSearchWidget extends StatelessWidget {
  final FocusNode focusNode;
  final Animation<double> animation;
  const _BuildSearchWidget({
    required this.focusNode,
    required this.animation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SearchDelegate(
        focusNode: focusNode,
        animation: animation,
      ),
    );
  }
}

class _SearchDelegate extends SliverPersistentHeaderDelegate {
  final FocusNode focusNode;
  final Animation<double> animation;
  const _SearchDelegate({
    required this.focusNode,
    required this.animation,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.all(kMainHorizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: !overlapsContent
            ? null
            : const Border(
                bottom: BorderSide(
                  width: 0.2,
                  color: AppColors.mainIconGrey,
                ),
              ),
      ),
      height: 70,
      child: _BuildSearchBlockWidget(
        focusNode: focusNode,
        animation: animation,
      ),
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _BuildSearchBlockWidget extends StatefulWidget {
  final FocusNode focusNode;
  final Animation<double> animation;
  const _BuildSearchBlockWidget({
    required this.focusNode,
    required this.animation,
    Key? key,
  }) : super(key: key);

  @override
  State<_BuildSearchBlockWidget> createState() =>
      _BuildSearchBlockWidgetState();
}

class _BuildSearchBlockWidgetState extends State<_BuildSearchBlockWidget>
// with SingleTickerProviderStateMixin
{
  late final TextEditingController _textController;
  // late final FocusNode _focusNode;
  // late final AnimationController _expandController;
  // late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: buildSearchField()),
        SizeTransition(
          axis: Axis.horizontal,
          axisAlignment: -1.0,
          sizeFactor: widget.animation,
          child: buildCancelButton(),
        ),
      ],
    );
  }

  TextField buildSearchField() {
    return TextField(
      controller: _textController,
      focusNode: widget.focusNode,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
        hintText: 'Найти город',
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.mainIconGrey,
        ),
        suffixIcon: _textController.text.isEmpty
            ? null
            : GestureDetector(
                onTap: _textController.clear,
                child: const Icon(
                  Icons.highlight_remove_rounded,
                  color: AppColors.mainIconGrey,
                ),
              ),
        filled: true,
        fillColor: AppColors.mainBgGrey,
        focusColor: Colors.green,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget buildCancelButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: DodoTextButton(
          text: 'Отмена',
          onTap: () {
            _textController.clear();
            widget.focusNode.unfocus();
          },
        ),
      ),
    );
  }
}

class _BuildCitiesListWidget extends StatelessWidget {
  final bool fullScreen;
  const _BuildCitiesListWidget({required this.fullScreen, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: kMainHorizontalPadding,
      ),
      sliver: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _BuildCityItemWidget(index, fullScreen),
              childCount: state.cities.length,
            ),
          );
        },
      ),
    );
  }
}

class _BuildCityItemWidget extends StatelessWidget {
  final int index;
  final bool fullScreen;
  const _BuildCityItemWidget(this.index, this.fullScreen, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            final selectedCity = state.cities[index];
            if (fullScreen) {
              unawaited(
                AppRouter.instance().replace(MainRouter(city: selectedCity)),
              );
            } else {
              unawaited(AppRouter.instance().pop(selectedCity.id));
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: kMainHorizontalPadding,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: AppColors.mainBgGrey,
                  width: 2,
                ),
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text(state.cities[index].name),
                  if (!fullScreen &&
                      state.selectedCity == state.cities[index]) ...[
                    const Spacer(),
                    const Icon(Icons.check)
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
