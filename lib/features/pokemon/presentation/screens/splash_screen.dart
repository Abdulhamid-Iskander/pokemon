import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';
import 'home_screen.dart';
import 'splash/particle.dart';
import 'splash/particle_painter.dart';
import 'splash/splash_pokeball_painter.dart';

class DynamicSplashScreen extends StatefulWidget {
  const DynamicSplashScreen({super.key});

  @override
  State<DynamicSplashScreen> createState() => _DynamicSplashScreenState();
}

class _DynamicSplashScreenState extends State<DynamicSplashScreen>
    with SingleTickerProviderStateMixin {
  late SplashTheme _selectedTheme;
  late List<Particle> _particles;
  late AnimationController _controller;
  final Random _random = Random();
  late DateTime _startTime;
  bool _navigationTriggered = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    final themes = SplashTheme.values;
    _selectedTheme = themes[_random.nextInt(themes.length)];
    _particles = List.generate(40, (index) => Particle(_selectedTheme, _random));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<HomeCubit>().state;
      if (state is! HomeLoading && state is! HomeInitial) {
        _checkAndNavigate();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAndNavigate() {
    if (_navigationTriggered) return;

    final elapsed = DateTime.now().difference(_startTime).inMilliseconds;
    const minDuration = 3000;

    if (elapsed >= minDuration) {
      _navigationTriggered = true;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      Future.delayed(Duration(milliseconds: minDuration - elapsed), () {
        if (mounted) _checkAndNavigate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _selectedTheme.color;

    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is! HomeLoading && state is! HomeInitial) {
          _checkAndNavigate();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0C0C12),
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            for (var p in _particles) {
              p.update(_selectedTheme);
            }

            return Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: ParticlePainter(
                      particles: _particles,
                      theme: _selectedTheme,
                      color: themeColor,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.2,
                        colors: [
                          themeColor.withOpacity(0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
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
                        _selectedTheme.label,
                        style: TextStyle(
                          color: themeColor.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
