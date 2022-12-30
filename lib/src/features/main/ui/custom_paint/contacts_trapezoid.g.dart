import 'package:flutter/material.dart';

class ContactsTrapezoid extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint0 = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.lineTo(size.width * 0.2500000, 0);
    path0.lineTo(size.width * 0.7500000, 0);
    path0.lineTo(size.width, size.height);
    path0.lineTo(0, size.height);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
