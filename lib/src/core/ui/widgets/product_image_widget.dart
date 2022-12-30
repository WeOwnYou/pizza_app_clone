import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductImageWidget extends StatelessWidget {
  final String url;
  final BoxFit? fit;
  final double? height;
  final double? width;
  const ProductImageWidget({
    required this.url,
    this.fit,
    this.height,
    this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: url,
      fit: fit,
      placeholder: (_, __) => SvgPicture.asset(AppImages.defaultImageSvg),
      // ignore: avoid_annotating_with_dynamic
      errorWidget: (_, __, dynamic ___) =>
          SvgPicture.asset(AppImages.defaultImageSvg),
    );
  }
}
