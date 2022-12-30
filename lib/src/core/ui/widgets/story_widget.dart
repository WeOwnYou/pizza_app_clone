import 'package:flutter/material.dart';

class StoryWidget extends StatefulWidget {
  final Color? bgColor;
  const StoryWidget({
    this.bgColor,
    Key? key,
  }) : super(key: key);

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final PageController _pageController;

  double scaleFactor = 1.0;

  void _onVerticalDragStart (DragStartDetails details) {}
  void _onVerticalDragUpdate (DragUpdateDetails details) {}
  void _onVerticalDragEnd (DragEndDetails details) {}

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: scaleFactor,
      child: Stack(
        children: [
          ColoredBox(
            color: widget.bgColor ?? Colors.black,
          ),
          Positioned(
              child: GestureDetector(
                onVerticalDragStart: _onVerticalDragStart,
                onVerticalDragUpdate: _onVerticalDragUpdate,
                onVerticalDragEnd: _onVerticalDragEnd,
              ),
          ),
        ],
      ),
    );
  }
}
