import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';
import 'home_screen.dart';
import 'splash/particle.dart';
import 'splash/particle_painter.dart';
import 'splash/splash_content.dart';

class DynamicSplashScreen extends StatefulWidget {
  const DynamicSplashScreen({super.key});

  @override
  State<DynamicSplashScreen> createState() => _DynamicSplashScreenState();
}

class _DynamicSplashScreenState extends State<DynamicSplashScreen> with SingleTickerProviderStateMixin {
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
                        colors: [themeColor.withOpacity(0.08), Colors.transparent],
                      ),
                    ),
                  ),
                ),
                SplashContent(theme: _selectedTheme, themeColor: themeColor),
              ],
            );
          },
        ),
      ),
    );
  }
}
