import 'dart:math';
import 'package:flutter/material.dart';

enum SplashTheme { fire, water, grass, electric, psychic }

extension SplashThemeExtension on SplashTheme {
  Color get color {
    switch (this) {
      case SplashTheme.fire:
        return const Color(0xFFFF5722);
      case SplashTheme.water:
        return const Color(0xFF2196F3);
      case SplashTheme.grass:
        return const Color(0xFF4CAF50);
      case SplashTheme.electric:
        return const Color(0xFFFFEB3B);
      case SplashTheme.psychic:
        return const Color(0xFF9C27B0);
    }
  }

  String get label {
    switch (this) {
      case SplashTheme.fire:
        return "FIRE COMBAT SYSTEM 🔴";
      case SplashTheme.water:
        return "WATER BATTLE SIMULATOR 🔵";
      case SplashTheme.grass:
        return "GRASS ENVIRONMENT ANALYZER 🟢";
      case SplashTheme.electric:
        return "ELECTRIC ENERGY FIELD 🟡";
      case SplashTheme.psychic:
        return "PSYCHIC FORECAST POWER 🟣";
    }
  }
}

class Particle {
  double x = 0;
  double y = 0;
  double speed = 0;
  double size = 0;
  double opacity = 0;
  double angle = 0;
  double swaySpeed = 0;
  double baseSize = 0;

  Particle(SplashTheme theme, Random random) {
    reset(theme, random, initial: true);
  }

  void reset(SplashTheme theme, Random random, {bool initial = false}) {
    x = random.nextDouble() * 400;
    y = initial
        ? random.nextDouble() * 800
        : (theme == SplashTheme.fire ? 850 : -50);
    speed = random.nextDouble() * 1.5 + 0.5;
    baseSize = random.nextDouble() * 6.0 + 2.0;
    size = baseSize;
    opacity = random.nextDouble() * 0.6 + 0.2;
    angle = random.nextDouble() * 2 * pi;
    swaySpeed = random.nextDouble() * 0.05 + 0.01;
  }

  void update(SplashTheme theme) {
    switch (theme) {
      case SplashTheme.fire:
        y -= speed * 1.5;
        x += sin(y * swaySpeed) * 0.5;
        opacity = (opacity - 0.001).clamp(0.0, 1.0);
        if (y < -20 || opacity <= 0) {
          reset(theme, Random());
        }
        break;
      case SplashTheme.water:
        y += speed * 2.0;
        x += sin(y * swaySpeed) * 0.3;
        if (y > 900) {
          reset(theme, Random());
        }
        break;
      case SplashTheme.grass:
        y += speed * 0.8;
        x += sin(y * swaySpeed) * 1.2;
        if (y > 900) {
          reset(theme, Random());
        }
        break;
      case SplashTheme.electric:
        opacity = (opacity - 0.04).clamp(0.0, 1.0);
        if (opacity <= 0) {
          reset(theme, Random(), initial: false);
          y = Random().nextDouble() * 800;
          x = Random().nextDouble() * 400;
        }
        break;
      case SplashTheme.psychic:
        angle += swaySpeed;
        size = baseSize * (1.0 + 0.4 * sin(angle * 3.0));
        y += speed * 0.3;
        if (y > 900) {
          reset(theme, Random());
        }
        break;
    }
  }
}
