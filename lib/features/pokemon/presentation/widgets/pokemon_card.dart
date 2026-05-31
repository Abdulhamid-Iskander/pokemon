import 'package:flutter/material.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../../../../core/theme/app_theme.dart';
import 'glass_card.dart';
import 'type_badge.dart';
import 'role_badge.dart';
import 'pokemon_card_image.dart';
import '../screens/analytics_screen.dart';

class PokemonCard extends StatefulWidget {
  final PokemonEntity pokemon;
  final int index;
  final Color? accentColor;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.index,
    this.accentColor,
  });

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final delay = (widget.index * 60).clamp(0, 600);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pokemon;
    final accent = widget.accentColor ?? AppTheme.typeColors[p.primaryType] ?? AppTheme.accent;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GlassCard(
          accentColor: accent,
          padding: EdgeInsets.zero,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AnalyticsScreen(
                  pokemonName: p.name,
                  initialEntity: p,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PokemonCardImage(pokemon: p, accentColor: accent),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${p.id.toString().padLeft(4, '0')}',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p.capitalizedName,
                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: p.types.map((t) => TypeBadge(type: t, small: true)).toList(),
                    ),
                    const SizedBox(height: 6),
                    RoleBadge(role: p.combatRole),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.bolt, color: AppTheme.accentSecondary, size: 12),
                        const SizedBox(width: 3),
                        Text(
                          'TCP ${p.trueCombatPower.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppTheme.accentSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
