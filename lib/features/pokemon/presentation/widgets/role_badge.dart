import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.roleColors[role] ?? AppTheme.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_roleIcon(role), color: color, size: 10),
          const SizedBox(width: 4),
          Text(
            role,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _roleIcon(String role) {
    switch (role) {
      case 'Tank':
        return Icons.shield;
      case 'Speedster':
        return Icons.flash_on;
      case 'Glass Cannon':
        return Icons.local_fire_department;
      default:
        return Icons.balance;
    }
  }
}
