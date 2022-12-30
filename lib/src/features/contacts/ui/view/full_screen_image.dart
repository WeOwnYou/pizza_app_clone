import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:flutter/material.dart';
import 'package:person_repository/person_repository.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

enum ImageIn { chat, search, panel }

class FullScreenImage extends StatefulWidget {
  final List<ChatImage> chatImages;
  final int selectedImageIndex;
  final ImageIn imageIn;
  const FullScreenImage({
    Key? key,
    required this.chatImages,
    required this.selectedImageIndex,
    required this.imageIn,
  }) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;

  ///activeImageIndex отвечает за картинку, со страницы которой осуществляется переход,
  late int activeImageIndex;

  ///activePageIndex отвечает за изменение страниц, когда она занимает большую часть экрана в appBar
  late int activePageIndex;
  late final String additionalTag;
  double opacity = 1;
  late final AnimationController _animationController;
  late PhotoViewController _photoViewController;
  Animation<double>? scaleAnimation;
  Animation<Offset>? offsetAnimation;

  @override
  void initState() {
    switch (widget.imageIn) {
      case ImageIn.chat:
        additionalTag = 'image_in_chat';
        break;
      case ImageIn.search:
        additionalTag = 'image_in_search';
        break;
      case ImageIn.panel:
        additionalTag = 'image_in_panel';
        break;
    }
    activeImageIndex = activePageIndex = widget.selectedImageIndex;
    _photoViewController = PhotoViewController();
    _pageController = PageController(initialPage: activePageIndex)
      ..addListener(() {
        setState(() {
          if (_pageController.page! % 1 == 0) {
            if (activeImageIndex == _pageController.page!.toInt()) return;
            setState(() {
              _photoViewController = PhotoViewController();
              activeImageIndex = _pageController.page!.toInt();
            });
          }
        });
      });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        _photoViewController.value = PhotoViewControllerValue(
          position: offsetAnimation?.value ?? _photoViewController.position,
          scale: scaleAnimation!.value,
          rotation: _photoViewController.rotation,
          rotationFocusPoint: _photoViewController.rotationFocusPoint,
        );
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(opacity),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(opacity),
        foregroundColor: Colors.black.withOpacity(opacity),
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () {
            AppRouter.instance().popTop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert,
              color: Colors.black.withOpacity(opacity),
            ),
          )
        ],
        title: Text(
          '${activePageIndex + 1} из ${widget.chatImages.length}',
          style: TextStyle(color: Colors.black.withOpacity(opacity)),
        ),
      ),
      body: Dismissible(
        direction: DismissDirection.vertical,
        onDismissed: (_) {
          AppRouter.instance().popTop();
        },
        onUpdate: (details) {
          setState(() {
            opacity = 1 - details.progress;
          });
        },
        key: Key(additionalTag),
        child: PhotoViewGallery.builder(
          pageController: _pageController,
          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
          itemCount: widget.chatImages.length,
          onPageChanged: (page) {
            setState(() {
              activePageIndex = page;
            });
          },
          builder: (ctx, index) {
            return PhotoViewGalleryPageOptions.customChild(
              controller:
                  index == activeImageIndex ? _photoViewController : null,
              heroAttributes: PhotoViewHeroAttributes(
                tag: '${widget.chatImages[index].imageId}$additionalTag',
              ),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 4.1,
              child: Image.memory(
                widget.chatImages[index].byteImage!,
                frameBuilder: (ctx, child, _, __) {
                  return FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        child: child,
                        onDoubleTap: () {},
                        onDoubleTapDown: (details) {
                          const scale = 3.0;
                          final height = MediaQuery.of(context).size.height;
                          final width = MediaQuery.of(context).size.width;
                          final tappedDx =
                              width - (details.globalPosition.dx * 2);
                          final tappedDy =
                              height - (details.globalPosition.dy * 2);
                          final tappedOffset = Offset(tappedDx, tappedDy);
                          final scaleValueEnd =
                              _photoViewController.scale == 1.0 ? scale : 1.0;
                          final offsetValueEnd =
                              _photoViewController.position == Offset.zero
                                  ? tappedOffset
                                  : Offset.zero;

                          scaleAnimation = Tween<double>(
                            begin: _photoViewController.scale,
                            end: scaleValueEnd,
                          ).animate(
                            CurveTween(curve: Curves.easeOut)
                                .animate(_animationController),
                          );
                          offsetAnimation = Tween<Offset>(
                            begin: _photoViewController.position,
                            end: offsetValueEnd,
                          ).animate(
                            CurveTween(curve: Curves.easeOut)
                                .animate(_animationController),
                          );
                          _animationController.forward(from: 0);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
