import 'package:flutter/material.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';

class ShoppingBagPizzaSlice extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    Paint paint1 = Paint()
      ..color = AppColors.mainBgOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(size.width * 0.4960000, size.height);
    path0.quadraticBezierTo(size.width * 0.8947333, size.height * 0.8173500,
        size.width, size.height * 0.6047000);
    path0.quadraticBezierTo(
        size.width * 0.9987333, size.height * 0.6069500, 0, 0);
    Path path1 = Path();
    path1.moveTo(0, 0);
    canvas.drawPath(path0, paint0);
    canvas.drawLine(Offset(0, size.height * 0.33),
        Offset(size.width, size.height * 0.33), paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
