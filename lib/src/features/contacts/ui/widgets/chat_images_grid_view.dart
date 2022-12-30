import 'package:dodo_clone/src/core/ui/utils/res/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:person_repository/person_repository.dart';

class ChatImagesGridView extends StatelessWidget {
  final List<ChatImage> images;
  final void Function(int imageIndex)? onImageTap;
  const ChatImagesGridView({
    Key? key,
    required this.images,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.6 * 0.89;
    const imageHeight = 300.0;
    if (images.length == 1) {
      return _SingleImageWidget(
        width: 300,
        height: imageHeight,
        borderRadius: kMainBorderRadius,
        padding: EdgeInsets.zero,
        image: images.first,
        imageIndex: 0,
        onImageTap: onImageTap,
      );
    } else if (images.length == 2) {
      return Row(
        children: [
          _SingleImageWidget(
            padding: EdgeInsets.zero,
            width: width * 0.6,
            height: imageHeight,
            borderRadius: kMainBorderRadius / 2,
            image: images.first,
            imageIndex: 0,
            onImageTap: onImageTap,
          ),
          _SingleImageWidget(
            padding: const EdgeInsets.only(left: 3),
            width: width * 0.4 - 3,
            height: imageHeight,
            borderRadius: kMainBorderRadius / images.length,
            image: images[1],
            imageIndex: 1,
            onImageTap: onImageTap,
          ),
        ],
      );
    } else if (images.length <= 4) {
      return SizedBox(
        width: 300,
        height: imageHeight,
        child: Row(
          children: [
            _SingleImageWidget(
              padding: EdgeInsets.zero,
              width: width * 0.6,
              height: imageHeight,
              borderRadius: kMainBorderRadius / 2,
              image: images.first,
              imageIndex: 0,
              onImageTap: onImageTap,
            ),
            Column(
              children: List.generate(images.length - 1, (index) {
                final isLast = index == (images.length - 2);
                return _SingleImageWidget(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 3, left: 3),
                  width: width * 0.4,
                  height: imageHeight * 1 / ((images.length) - 1) -
                      (isLast ? 0 : 3),
                  borderRadius: kMainBorderRadius / images.length,
                  image: images[index + 1],
                  imageIndex: index + 1,
                  onImageTap: onImageTap,
                );
              }),
            )
          ],
        ),
      );
    } else {
      late final int numberOfThreeInARow;
      late final int numberOfTwoInARow;
      switch (images.length % 3) {
        case 0:
          numberOfThreeInARow = images.length ~/ 3;
          numberOfTwoInARow = 0;
          break;
        case 1:
          numberOfThreeInARow = images.length ~/ 3 - 1;
          numberOfTwoInARow = 2;
          break;
        case 2:
          numberOfThreeInARow = images.length ~/ 3;
          numberOfTwoInARow = 1;
          break;
      }
      return Column(
        children: [
          ...List.generate(
            numberOfTwoInARow,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                children: List.generate(
                  2,
                  (subIndex) => _SingleImageWidget(
                    padding: EdgeInsets.only(left: subIndex == 0 ? 0 : 3),
                    width: width * 0.5 - 3,
                    height: imageHeight / 2,
                    borderRadius: kMainBorderRadius / (numberOfTwoInARow * 2),
                    image: images[index * 2 + subIndex],
                    imageIndex: index * 2 + subIndex,
                    onImageTap: onImageTap,
                  ),
                ),
              ),
            ),
          ),
          ...List.generate(
            numberOfThreeInARow,
            (index) => Padding(
              padding: const EdgeInsets.only(
                bottom: 3,
              ),
              child: Row(
                children: List.generate(
                  3,
                  (subIndex) => _SingleImageWidget(
                    padding: EdgeInsets.only(left: subIndex == 0 ? 0 : 3),
                    width: width * 0.33 - 2 * 3,
                    height: imageHeight / 2,
                    borderRadius: kMainBorderRadius / (numberOfThreeInARow * 3),
                    image: images[index * 3 + subIndex],
                    imageIndex: index * 3 + subIndex,
                    onImageTap: onImageTap,
                  ),
                ),
              ),
            ),
          )
        ],
      );
      // return const FlutterLogo();
    }
  }
}

class _SingleImageWidget extends StatelessWidget {
  final EdgeInsets padding;
  final double width;
  final double height;
  final double borderRadius;
  final ChatImage image;
  final int imageIndex;
  final void Function(int imageIndex)? onImageTap;
  const _SingleImageWidget({
    Key? key,
    required this.padding,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.image,
    required this.imageIndex,
    this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        width: width,
        child: Image.memory(
          image.byteImage!,
          fit: BoxFit.cover,
          frameBuilder: (ctx, child, __, ___) {
            return GestureDetector(
              onTap: () {
                if (onImageTap != null) {
                  // print('${image.imageId!}image_in_chat');
                  onImageTap!(imageIndex);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child:
                    Hero(tag: '${image.imageId!}image_in_chat', child: child),
              ),
            );
          },
        ),
      ),
    );
  }
}
