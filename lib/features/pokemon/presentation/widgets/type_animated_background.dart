import 'dart:math' as math;
import 'package:flutter/material.dart';

class TypeAnimatedBackground extends StatefulWidget {
  final String type;
  const TypeAnimatedBackground({super.key, required this.type});
  @override
  State<TypeAnimatedBackground> createState() => _TypeAnimatedBackgroundState();
}

class _TypeAnimatedBackgroundState extends State<TypeAnimatedBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_P> _p = [];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    for (int i = 0; i < 20; i++) {
      _p.add(_P(_random.nextDouble(), _random.nextDouble(), _random.nextDouble() * 6 + 2, _random.nextDouble() * 0.02 + 0.005, _random.nextDouble() * 0.5 + 0.2));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final type = widget.type.toLowerCase();
        for (var p in _p) {
          if (type == 'fire' || type == 'water') {
            p.y -= p.speed;
            p.x += math.sin(p.y * 10) * 0.002;
            if (p.y < 0) { p.y = 1.0; p.x = _random.nextDouble(); }
          } else if (type == 'grass') {
            p.y += p.speed * 0.7;
            p.x += math.sin(p.y * 8) * 0.003;
            if (p.y > 1.0) { p.y = 0.0; p.x = _random.nextDouble(); }
          } else if (type == 'electric') {
            if (_random.nextDouble() < 0.15) { p.x = _random.nextDouble(); p.y = _random.nextDouble(); p.opacity = _random.nextDouble() * 0.8 + 0.2; }
          } else {
            p.y -= p.speed * 0.3;
            p.x += math.cos(p.y * 5) * 0.001;
            if (p.y < 0) { p.y = 1.0; p.x = _random.nextDouble(); }
          }
        }
        return CustomPaint(painter: _ParticlePainter(_p, type), child: Container());
      },
    );
  }
}

class _P {
  double x, y, size, speed, opacity;
  _P(this.x, this.y, this.size, this.speed, this.opacity);
}

class _ParticlePainter extends CustomPainter {
  final List<_P> particles;
  final String type;
  _ParticlePainter(this.particles, this.type);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var p in particles) {
      final dx = p.x * size.width;
      final dy = p.y * size.height;
      
      Color baseColor = Colors.white.withOpacity(p.opacity * 0.4);
      if (type == 'fire') baseColor = Colors.orangeAccent.withOpacity(p.opacity);
      if (type == 'water') baseColor = Colors.cyanAccent.withOpacity(p.opacity * 0.6);
      if (type == 'grass') baseColor = Colors.greenAccent.withOpacity(p.opacity * 0.8);
      if (type == 'electric') baseColor = Colors.yellowAccent.withOpacity(p.opacity);
      if (type == 'psychic' || type == 'ghost' || type == 'fairy') baseColor = Colors.purpleAccent.withOpacity(p.opacity * 0.7);

      paint.color = baseColor;
      if (type == 'electric') {
        final path = Path()
          ..moveTo(dx, dy)
          ..lineTo(dx + p.size * 0.5, dy - p.size)
          ..lineTo(dx + p.size, dy - p.size)
          ..lineTo(dx + p.size * 0.3, dy + p.size * 0.5)
          ..close();
        canvas.drawPath(path, paint);
      } else if (type == 'grass') {
        canvas.drawOval(Rect.fromCenter(center: Offset(dx, dy), width: p.size * 1.5, height: p.size * 0.8), paint);
      } else {
        canvas.drawCircle(Offset(dx, dy), p.size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
