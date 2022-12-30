import 'package:dodo_clone/src/core/ui/utils/extensions/int_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:flutter/material.dart';

const _paddingBetweenPrices = 5;

class CartItemPriceWidget extends StatelessWidget {
  const CartItemPriceWidget({
    Key? key,
    required this.price,
    required this.maxWidth,
    this.oldPrice,
  }) : super(key: key);

  final int price;
  final int? oldPrice;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    // TODO(mes): подумать/пофиксить
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: CustomPaint(
        painter: CustomPricePainter(
          price: price.rubles,
          lineColor: AppColors.mainBgOrange.withOpacity(0.7),
          oldPrice: oldPrice?.rubles,
          maxWidth: maxWidth,
        ),
      ),
    );
  }
}

class CustomPricePainter extends CustomPainter {
  final Color lineColor;
  final double lineWidth;
  final String price;
  final String? oldPrice;
  final TextStyle? textStyle;
  final double maxWidth;
  CustomPricePainter({
    required this.price,
    TextStyle? textStyle,
    this.oldPrice,
    required this.lineColor,
    required this.maxWidth,
    this.lineWidth = 2.5,
  }) : textStyle = textStyle == null
            ? const TextStyle().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )
            : textStyle.fontSize != null
                ? textStyle
                : textStyle.copyWith(fontSize: 14);
  @override
  void paint(Canvas canvas, Size size) {
    final priceSpan = TextSpan(text: price, style: textStyle);
    final pricePainter = TextPainter(
      text: priceSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset.zero);

    if (oldPrice != null) {
      drawOldPrice(canvas, pricePainter.size);
    }
  }

  void drawOldPrice(Canvas canvas, Size prevPriceSize) {
    final oldPriceSpan = TextSpan(
      text: oldPrice,
      style: TextStyle(
        fontSize: textStyle!.fontSize, // - 2,
        color: AppColors.mainTextGrey,
      ),
    );
    final oldPricePainter = TextPainter(
      text: oldPriceSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    )..layout();
    final leftOffset = Offset(prevPriceSize.width + _paddingBetweenPrices, 0);
    final topOffset = Offset(0, prevPriceSize.height + _paddingBetweenPrices);
    late final Offset p1;
    late final Offset p2;
    late final double y;
    late final double x;
    final path = Path();
    if (maxWidth > leftOffset.dx + oldPricePainter.width) {
      p1 = Offset(
        leftOffset.dx + oldPricePainter.width,
        oldPricePainter.height * 0.25,
      );
      p2 = Offset(
        prevPriceSize.width * 1.14,
        oldPricePainter.height * 0.8,
      );
      y = p1.dy * 0.8;
      x = (p1.dx + leftOffset.dx) * 0.55;
    } else {
      p1 = Offset(
        oldPricePainter.width * 0.01,
        (topOffset.dy + oldPricePainter.height) * 0.9,
      );
      p2 = Offset(
        oldPricePainter.width,
        topOffset.dy * 1.2,
      );
      y = p2.dy * 1.1;
      x = (p1.dx - p2.dx).abs() * 0.3;
    }

    path.moveTo(p1.dx, p1.dy);
    oldPricePainter.paint(
      canvas,
      maxWidth > (leftOffset.dx + oldPricePainter.width)
          ? leftOffset
          : topOffset,
    );
    final paintLine = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;
    path.quadraticBezierTo(x, y, p2.dx, p2.dy);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(CustomPricePainter oldDelegate) => false;
}
