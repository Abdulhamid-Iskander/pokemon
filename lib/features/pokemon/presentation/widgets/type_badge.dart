import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class TypeBadge extends StatelessWidget {
  final String type;
  final bool small;

  const TypeBadge({super.key, required this.type, this.small = false});

  @override
  Widget build(BuildContext context) {
    final color =
        AppTheme.typeColors[type.toLowerCase()] ?? AppTheme.textMuted;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6), width: 1),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: small ? 8 : 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
