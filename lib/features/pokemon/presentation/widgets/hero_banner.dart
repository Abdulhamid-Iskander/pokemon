import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../../../../core/theme/app_theme.dart';
import 'type_badge.dart';
import '../screens/analytics_screen.dart';

class HeroBanner extends StatefulWidget {
  final PokemonEntity hero;

  const HeroBanner({super.key, required this.hero});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
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
    final p = widget.hero;
    final accent = AppTheme.typeColors[p.primaryType] ?? AppTheme.accent;

    return ScaleTransition(
      scale: _scaleAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AnalyticsScreen(
                pokemonName: p.name,
                initialEntity: p,
              ),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            constraints: const BoxConstraints(minHeight: 160),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent.withOpacity(0.3), accent.withOpacity(0.05)],
              ),
              border: Border.all(color: accent.withOpacity(0.4), width: 1.5),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Hero(
                    tag: 'pokemon-${p.id}',
                    child: p.imageUrl.isNotEmpty
                        ? CachedNetworkImage(imageUrl: p.imageUrl, fit: BoxFit.contain)
                        : const Icon(Icons.catching_pokemon, size: 80, color: Colors.white24),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '⚡ TOP FIGHTER',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 9,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.capitalizedName,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          children: p.types.map((t) => TypeBadge(type: t)).toList(),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'TCP ${p.trueCombatPower.toStringAsFixed(1)}',
                          style: TextStyle(color: accent, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
