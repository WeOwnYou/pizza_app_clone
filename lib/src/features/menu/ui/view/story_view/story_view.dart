// import 'dart:math';
//
// import 'package:auto_route/auto_route.dart';
// import 'package:dodo_clone/src/core/ui/widgets/product_image_widget.dart';
// import 'package:dodo_clone/src/features/menu/bloc/story_bloc/story_bloc.dart';
// import 'package:dodo_clone/src/features/menu/bloc/story_bloc/story_event.dart';
// import 'package:dodo_clone/src/features/menu/bloc/story_bloc/story_state.dart';
// import 'package:dodo_clone_repository/dodo_clone_repository.dart'
//     hide MediaType;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// part 'story_failure_view.dart';
// part 'story_initial_view.dart';
//
// class StoryView extends StatefulWidget with AutoRouteWrapper {
//   final int _initialStoryIndex;
//   StoryView(
//     this._initialStoryIndex, {
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget wrappedRoute(BuildContext context) {
//     return BlocProvider(
//       create: (_) => StoryBloc(
//         dodoCloneRepository: context.read<IDodoCloneRepository>(),
//         initialStoryIndex: _initialStoryIndex,
//       ),
//       child: this,
//       lazy: false,
//     );
//   }
//
//   @override
//   State<StoryView> createState() => _StoryViewState();
// }
//
// class _StoryViewState extends State<StoryView> with TickerProviderStateMixin {
//   late final AnimationController _animationController;
//   late final PageController _pageController;
//   double startPosition = 0;
//   double top = 0;
//   double bottom = 0;
//   double left = 0;
//   double right = 0;
//   double scaleFactor = 1.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(vsync: this)
//       ..addListener(() {
//         if (_animationController.isCompleted) {
//           _animationController.reset();
//           _onTapDown(true);
//           // context.read<StoryBloc>().add(const StoryChangeEvent(true));
//         }
//         setState(() {});
//       });
//     _pageController = PageController(initialPage: widget._initialStoryIndex)
//       ..addListener(pageControllerListener);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void pageControllerListener() {
//     if (context.read<StoryBloc>().state is! StoryStateSuccess) return;
//     if ((_pageController.page ?? 0) % 1 != 0) {
//       _animationController.stop();
//     } else {
//       if (_pageController.page ==
//           (context.read<StoryBloc>().state as StoryStateSuccess)
//               .storyActiveIndex) {
//         _animationController.forward();
//       } else {
//         context.read<StoryBloc>().add(
//               StoryChangeEvent(
//                 storyIndex: (_pageController.page ?? 0.0).toInt(),
//               ),
//             );
//         _animationController
//           ..reset()
//           ..forward();
//       }
//     }
//   }
//
//   void _onTapDown(bool forward) {
//     final state = context.read<StoryBloc>().state;
//     if (state is! StoryStateSuccess) return;
//
//     /// ресетим контроллер на время вычислений действия
//     _animationController
//       ..reset()
//       ..stop();
//
//     /// вычисляем, на какую часть экрана нажал пользователь
//     final pageNextIndex = forward ? 1 : -1;
//     if (state.storyItemActiveIndex + pageNextIndex >=
//             state.currentStory.storyItems.length ||
//         state.storyItemActiveIndex + pageNextIndex < 0) {
//       /// свапнуть Story (также item = 0)
//       if (state.storyActiveIndex < state.stories.length - pageNextIndex) {
//         context.read<StoryBloc>().add(
//               StoryChangeEvent(
//                 storyIndex: max(0, state.storyActiveIndex + pageNextIndex),
//               ),
//             );
//         if (state.storyActiveIndex + pageNextIndex >= 0) {
//           _pageController.jumpToPage(state.storyActiveIndex + pageNextIndex);
//         }
//       } else {
//         _animationController.stop();
//         context.read<StoryBloc>().add(StoryCloseEvent());
//       }
//     } else {
//       /// свапнуть StoryItem
//       context.read<StoryBloc>().add(
//             StoryChangeEvent(
//               storyItemIndex: state.storyItemActiveIndex + pageNextIndex,
//             ),
//           );
//     }
//     _animationController
//       ..duration = state.currentStoryItem.duration
//       ..forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Opacity(
//         opacity: scaleFactor,
//         child: Stack(
//           children: [
//             Container(
//               color: Colors.black,
//             ),
//             Positioned(
//               top: top,
//               bottom: bottom,
//               right: right,
//               left: left,
//               child: ColoredBox(
//                 color: Colors.black,
//                 child: BlocBuilder<StoryBloc, StoryState>(
//                   buildWhen: (prevState, curState) {
//                     if (prevState != curState &&
//                         curState is StoryStateSuccess) {
//                       _animationController
//                         ..duration = curState.stories[widget._initialStoryIndex]
//                             .storyItems.first.duration
//                         ..forward();
//                     }
//                     return true;
//                   },
//                   builder: (context, state) {
//                     switch (state.runtimeType) {
//                       case StoryStateInitial:
//                         return const _StoryInitialView();
//                       case StoryStateFailure:
//                         return const _StoryFailureView();
//                       case StoryStateSuccess:
//                         return GestureDetector(
//                           onVerticalDragStart: (details) {
//                             startPosition = details.localPosition.dy;
//                           },
//                           onVerticalDragEnd: (details) {
//                             if (top >
//                                 MediaQuery.of(context).size.height * 0.2) {
//                               context.read<StoryBloc>().add(StoryCloseEvent());
//                             } else {
//                               _animationController.forward();
//                               setState(() {
//                                 top = 0;
//                                 bottom = 0;
//                                 scaleFactor = 1;
//                               });
//                             }
//                           },
//                           onVerticalDragUpdate: (details) {
//                             _animationController.stop();
//                             setState(() {
//                               top = details.localPosition.dy - startPosition;
//                               bottom =
//                                   -(details.localPosition.dy - startPosition);
//                               final progress = top /
//                                   (MediaQuery.of(context).size.height / 100) /
//                                   100;
//                               scaleFactor = min(1, 1 - progress);
//                             });
//                           },
//                           child: PageView(
//                             onPageChanged: (index) {},
//                             controller: _pageController,
//                             children: (state as StoryStateSuccess)
//                                 .stories
//                                 .asMap()
//                                 .entries
//                                 .map(
//                                   (e) => _BuildStoryWidget(
//                                     storyIndex: e.key,
//                                     storyItem: state.currentStoryItem,
//                                     storyItemsLength: e.value.storyItems.length,
//                                     onTapDown: (details) {
//                                       final centerWidth =
//                                           MediaQuery.of(context).size.width / 2;
//                                       final forward =
//                                           details.globalPosition.dx >
//                                               centerWidth;
//                                       _onTapDown(forward);
//                                     },
//                                     progressValue:
//                                         state.storyActiveIndex == e.key
//                                             ? _animationController.value
//                                             : 0,
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         );
//                       default:
//                         return Container();
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _BuildStoryWidget extends StatelessWidget {
//   final int storyIndex;
//   final StoryItem storyItem;
//   final int storyItemsLength;
//   final void Function(TapUpDetails) onTapDown;
//   final double progressValue;
//   const _BuildStoryWidget({
//     required this.storyIndex,
//     required this.storyItem,
//     required this.storyItemsLength,
//     required this.progressValue,
//     required this.onTapDown,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             _BuildStoryContentWidget(
//               onTapDown: onTapDown,
//             ),
//             _BuildStoryProgressBarWidget(
//               storyIndex: storyIndex,
//               progressIndicatorCount: storyItemsLength,
//               progressValue: progressValue,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _BuildStoryProgressBarWidget extends StatelessWidget {
//   final int storyIndex;
//   final int progressIndicatorCount;
//   final double progressValue;
//   const _BuildStoryProgressBarWidget({
//     Key? key,
//     required this.storyIndex,
//     required this.progressValue,
//     required this.progressIndicatorCount,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: 0,
//       right: 0,
//       // width: 200,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: BlocBuilder<StoryBloc, StoryState>(
//           builder: (context, state) {
//             return Row(
//               children: [
//                 ...List.generate(
//                   progressIndicatorCount,
//                   (index) {
//                     var currentValue = 0.0;
//                     if (index >
//                         (state as StoryStateSuccess)
//                             .storyItemsActiveIndexes[storyIndex]) {
//                       currentValue = 0;
//                     } else if (index <
//                         state.storyItemsActiveIndexes[storyIndex]) {
//                       currentValue = 1;
//                     } else {
//                       currentValue = progressValue;
//                     }
//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: LinearProgressIndicator(
//                           backgroundColor: Colors.grey,
//                           valueColor:
//                               const AlwaysStoppedAnimation<Color>(Colors.white),
//                           value: currentValue,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     context.read<StoryBloc>().add(StoryCloseEvent());
//                   },
//                   child: const Icon(
//                     Icons.close,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class _BuildStoryContentWidget extends StatelessWidget {
//   final void Function(TapUpDetails) onTapDown;
//   const _BuildStoryContentWidget({
//     required this.onTapDown,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: 0,
//       right: 0,
//       bottom: 0,
//       top: 0,
//       child: GestureDetector(
//         onTapUp: onTapDown,
//         child: BlocBuilder<StoryBloc, StoryState>(
//           builder: (context, state) {
//             return ProductImageWidget(
//               url: (state as StoryStateSuccess).currentStoryItem.link,
//               fit: BoxFit.fill,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
