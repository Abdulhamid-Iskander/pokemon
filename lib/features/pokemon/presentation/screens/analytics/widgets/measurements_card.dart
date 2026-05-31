import 'package:flutter/material.dart';
import '../../../../domain/entities/pokemon_entity.dart';
import '../../../widgets/glass_card.dart';
import '../../../../../../core/theme/app_theme.dart';

class MeasurementsCard extends StatelessWidget {
  final PokemonEntity pokemon;
  final Color accentColor;

  const MeasurementsCard({
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _measureStat(Icons.height, 'HEIGHT', '${pokemon.heightM.toStringAsFixed(1)} m'),
            _measureStat(
                Icons.monitor_weight_outlined, 'WEIGHT', '${pokemon.weightKg.toStringAsFixed(1)} kg'),
          ],
        ),
      ),
    );
  }

  Widget _measureStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.textMuted, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
      ],
    );
  }
}
