import 'package:flutter/material.dart';
import 'particle.dart';
import 'splash_pokeball_painter.dart';

class SplashContent extends StatelessWidget {
  final SplashTheme theme;
  final Color themeColor;

  const SplashContent({
    super.key,
    required this.theme,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.85, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: SplashPokeballPainter(themeColor),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'COMBAT ANALYTICS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 4.0,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'SMART INTELLIGENCE SYSTEM',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 60),
          SizedBox(
            width: 40,
            height: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                color: themeColor,
                backgroundColor: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            theme.label,
            style: TextStyle(
              color: themeColor.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
