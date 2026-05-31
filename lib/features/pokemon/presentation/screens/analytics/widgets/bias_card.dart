import 'package:flutter/material.dart';
import '../../../domain/entities/pokemon_entity.dart';
import '../../widgets/glass_card.dart';
import '../../../../../../core/theme/app_theme.dart';

class BiasCard extends StatelessWidget {
  final PokemonEntity pokemon;
  final Color accentColor;

  const BiasCard({
    super.key,
    required this.pokemon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        accentColor: accentColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PHYSICAL vs SPECIAL BIAS',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.5),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Row(
                children: [
                  Expanded(
                    flex: (pokemon.physicalBias * 100).round(),
                    child: Container(height: 10, color: accentColor),
                  ),
                  Expanded(
                    flex: ((1 - pokemon.physicalBias) * 100).round(),
                    child: Container(height: 10, color: Colors.purple.shade400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Physical ${(pokemon.physicalBias * 100).toStringAsFixed(0)}%',
                  style: TextStyle(color: accentColor, fontSize: 11),
                ),
                Text(
                  'Special ${((1 - pokemon.physicalBias) * 100).toStringAsFixed(0)}%',
                  style: TextStyle(color: Colors.purple.shade400, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
