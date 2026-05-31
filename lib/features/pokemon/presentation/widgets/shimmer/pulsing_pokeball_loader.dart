import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class PulsingPokeballLoader extends StatefulWidget {
  final double size;
  final String label;

  const PulsingPokeballLoader({
    super.key,
    this.size = 80.0,
    this.label = 'Loading combat data...',
  });

  @override
  State<PulsingPokeballLoader> createState() => _PulsingPokeballLoaderState();
}

class _PulsingPokeballLoaderState extends State<PulsingPokeballLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnim,
            child: RotationTransition(
              turns: _controller,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent,
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: _PokeballPainter(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PokeballPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final redPaint = Paint()..color = AppTheme.accent;
    final whitePaint = Paint()..color = Colors.white;
    final blackPaint = Paint()
      ..color = const Color(0xFF121212)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08;

    final fillBlackPaint = Paint()..color = const Color(0xFF121212);

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, 3.14159, 3.14159, true, redPaint);

    canvas.drawArc(rect, 0, 3.14159, true, whitePaint);

    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      blackPaint,
    );

    final borderPaint = Paint()
      ..color = const Color(0xFF121212)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08;
    canvas.drawCircle(center, radius, borderPaint);

    canvas.drawCircle(center, radius * 0.28, fillBlackPaint);

    canvas.drawCircle(center, radius * 0.14, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
