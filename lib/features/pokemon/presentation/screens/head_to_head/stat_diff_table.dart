import 'package:flutter/material.dart';
import '../../../domain/entities/pokemon_entity.dart';
import '../../widgets/glass_card.dart';
import '../../../../../../core/theme/app_theme.dart';

class StatDiffTable extends StatelessWidget {
  final Map<String, int> diff;
  final PokemonEntity pokemonA;
  final PokemonEntity pokemonB;

  const StatDiffTable({
    super.key,
    required this.diff,
    required this.pokemonA,
    required this.pokemonB,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('HP', pokemonA.hp, pokemonB.hp),
      ('Attack', pokemonA.attack, pokemonB.attack),
      ('Defense', pokemonA.defense, pokemonB.defense),
      ('Sp. Atk', pokemonA.spAtk, pokemonB.spAtk),
      ('Sp. Def', pokemonA.spDef, pokemonB.spDef),
      ('Speed', pokemonA.speed, pokemonB.speed),
    ];

    return GlassCard(
      child: Column(
        children: stats.map((s) {
          final delta = s.$2 - s.$3;
          final aWins = delta > 0;
          final tie = delta == 0;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    s.$2.toString(),
                    style: TextStyle(
                      color: aWins ? AppTheme.accent : AppTheme.textMuted,
                      fontWeight: aWins ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      s.$1,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    s.$3.toString(),
                    style: TextStyle(
                      color: !aWins && !tie ? AppTheme.accentSecondary : AppTheme.textMuted,
                      fontWeight: !aWins && !tie ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
