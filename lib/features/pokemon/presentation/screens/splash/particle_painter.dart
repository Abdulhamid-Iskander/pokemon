import 'package:flutter/material.dart';
import 'particle.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final SplashTheme theme;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.theme,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      paint.color = color.withOpacity(p.opacity);

      final px = p.x % size.width;
      final py = p.y % size.height;

      if (theme == SplashTheme.electric) {
        final path = Path()
          ..moveTo(px, py)
          ..lineTo(px - p.size, py + p.size * 1.5)
          ..lineTo(px + p.size * 0.2, py + p.size * 1.6)
          ..lineTo(px - p.size * 0.5, py + p.size * 3.0)
          ..lineTo(px + p.size * 0.8, py + p.size * 1.2)
          ..lineTo(px + p.size * 0.2, py + p.size * 1.1)
          ..close();
        canvas.drawPath(path, paint);
      } else if (theme == SplashTheme.grass) {
        final rect = Rect.fromCenter(
            center: Offset(px, py), width: p.size * 1.8, height: p.size * 0.9);
        canvas.drawOval(rect, paint);
      } else {
        canvas.drawCircle(Offset(px, py), p.size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
