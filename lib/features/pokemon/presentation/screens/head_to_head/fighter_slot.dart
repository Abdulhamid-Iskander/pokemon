import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/pokemon_entity.dart';
import '../../../cubit/head_to_head_cubit.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/type_badge.dart';
import '../_pokemon_picker_sheet.dart';
import '../../../../../../core/theme/app_theme.dart';

class FighterSlot extends StatelessWidget {
  final PokemonEntity? pokemon;
  final String label;
  final bool isA;
  final Color accentColor;

  const FighterSlot({
    super.key,
    required this.pokemon,
    required this.label,
    required this.isA,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const PokemonPickerSheet(),
        );
        if (picked != null && context.mounted) {
          context.read<HeadToHeadCubit>().selectPokemon(picked, isA: isA);
        }
      },
      child: GlassCard(
        accentColor: accentColor,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: accentColor,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (pokemon != null) ...[
              pokemon!.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: pokemon!.imageUrl,
                      height: 80,
                      fit: BoxFit.contain,
                    )
                  : const Icon(Icons.catching_pokemon, size: 60, color: Colors.white24),
              const SizedBox(height: 6),
              Text(
                pokemon!.capitalizedName,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                alignment: WrapAlignment.center,
                children: pokemon!.types.map((t) => TypeBadge(type: t, small: true)).toList(),
              ),
              const SizedBox(height: 4),
              Text(
                'TCP ${pokemon!.trueCombatPower.toStringAsFixed(0)}',
                style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ] else ...[
              const SizedBox(height: 80),
              Icon(Icons.add_circle_outline, color: accentColor, size: 32),
              const SizedBox(height: 6),
              Text(
                'Select Fighter',
                style: TextStyle(color: accentColor.withOpacity(0.7), fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
