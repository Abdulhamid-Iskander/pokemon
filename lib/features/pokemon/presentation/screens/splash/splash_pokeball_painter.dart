import 'package:flutter/material.dart';

class SplashPokeballPainter extends CustomPainter {
  final Color themeColor;

  SplashPokeballPainter(this.themeColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final redPaint = Paint()..color = themeColor;
    final whitePaint = Paint()..color = Colors.white.withOpacity(0.9);
    final blackPaint = Paint()
      ..color = const Color(0xFF0C0C12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08;

    final fillBlackPaint = Paint()..color = const Color(0xFF0C0C12);

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, 3.14159, 3.14159, true, redPaint);

    canvas.drawArc(rect, 0, 3.14159, true, whitePaint);

    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      blackPaint,
    );

    final borderPaint = Paint()
      ..color = const Color(0xFF0C0C12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08;
    canvas.drawCircle(center, radius, borderPaint);

    canvas.drawCircle(center, radius * 0.28, fillBlackPaint);

    canvas.drawCircle(center, radius * 0.14, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
