import 'package:flutter/material.dart';
import '../../../../domain/entities/pokemon_entity.dart';
import '../../../widgets/glass_card.dart';
import '../../../../../../core/theme/app_theme.dart';

class TcpCard extends StatelessWidget {
  final PokemonEntity pokemon;
  final Color accentColor;

  const TcpCard({
    super.key,
    required this.pokemon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassCard(
        accentColor: accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _tcpStat('TRUE COMBAT POWER', pokemon.trueCombatPower.toStringAsFixed(1), accentColor),
            _tcpStat('TOTAL STATS', pokemon.totalStats.toString(), AppTheme.textSecondary),
            _tcpStat(
                'PHYS BIAS',
                '${(pokemon.physicalBias * 100).toStringAsFixed(0)}%',
                AppTheme.accentSecondary),
          ],
        ),
      ),
    );
  }

  Widget _tcpStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textMuted, fontSize: 9, letterSpacing: 0.8),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
