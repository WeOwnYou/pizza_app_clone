part of 'menu_view.dart';

class AnimatedProduct extends StatefulWidget {
  final ScrollController menuController;
  final AnimationController animationController;
  final double opacity;
  final double? scale;
  const AnimatedProduct({
    required this.menuController,
    required this.animationController,
    required this.opacity,
    required this.scale,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedProduct> createState() => _AnimatedProductState();
}

class _AnimatedProductState extends State<AnimatedProduct> {
  bool needToRender = false;
  bool scrollingInProgress = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuBloc, MenuState>(
      listener: (context, state) async {
        if (scrollingInProgress) return;
        scrollingInProgress = true;
        if (state.needToScrollAtProduct) {
          await widget.menuController
              .animateTo(
            min(
              widget.menuController.position.maxScrollExtent,
              MediaQuery.of(context).size.height * 0.48 +
                  state.animatedProductIndex * MenuConstants.productHeight,
            ),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          )
              .whenComplete(() {
            context.read<MenuBloc>().add(MenuEndScrollingAtProduct());
          });
        }
        if (state.needToAnimateProduct && !needToRender) {
          setState(() {
            needToRender = true;
          });
          await widget.animationController.forward().whenComplete(() {
            context.read<MenuBloc>().add(MenuEndAnimatingProduct());
            setState(() {
              needToRender = false;
            });
            scrollingInProgress = false;
            widget.animationController.reset();
          });
        }
      },
      listenWhen: (old, state) {
        return state
            .needToAnimateProduct; //old.needToAnimateProduct == state.needToAnimateProduct;
      },
      builder: (context, state) {
        final screenSize = MediaQuery.of(context).size;
        final positionAnimation = Tween<Offset>(
          begin: Offset(
            kMainHorizontalPadding,
            screenSize.height *
                    (MenuConstants.addressFromHeight +
                        MenuConstants.storyFromHeight +
                        MenuConstants.specialBlockFromHeight) -
                context.select<MenuBloc, double>(
                  (value) {
                    return widget.menuController.hasClients
                        ? widget.menuController.position.pixels
                        : 0;
                  },
                ) +
                (MenuConstants.productHeight * state.animatedProductIndex) +
                50 +
                MenuConstants.productHeight / 4,
          ),
          end: Offset(
            screenSize.width - MenuConstants.productHeight / 2,
            screenSize.height -
                MenuConstants.productHeight / 2 -
                kBottomNavigationBarHeight -
                MediaQuery.of(context).padding.bottom,
          ),
        ).animate(widget.animationController);
        if (!needToRender) return const SizedBox.shrink();
        return AnimatedBuilder(
          animation: widget.animationController,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: ProductImageWidget(
              url: state.deliverProducts[state.animatedProductIndex].image,
              fit: BoxFit.contain,
            ),
          ),
          builder: (context, child) {
            return Positioned(
              height: MenuConstants.productHeight / 2,
              left: positionAnimation.value.dx,
              top: positionAnimation.value.dy,
              child: Transform.scale(
                scale: widget.scale,
                child: Opacity(
                  opacity: widget.opacity,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
