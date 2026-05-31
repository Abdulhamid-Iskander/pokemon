import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/entities/pokemon_entity.dart';
import '../../../widgets/type_badge.dart';
import '../../../widgets/role_badge.dart';
import '../../../widgets/type_animated_background.dart';
import '../../../../../../core/theme/app_theme.dart';

class AnalyticsHeader extends StatelessWidget {
  final PokemonEntity pokemon;
  final Color accentColor;

  const AnalyticsHeader({
    super.key,
    required this.pokemon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [accentColor.withOpacity(0.3), AppTheme.background],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: TypeAnimatedBackground(type: pokemon.primaryType),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Hero(
                    tag: 'pokemon-${pokemon.id}',
                    child: pokemon.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: pokemon.imageUrl,
                            height: 160,
                            fit: BoxFit.contain,
                          )
                        : const Icon(Icons.catching_pokemon, size: 120, color: Colors.white24),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${pokemon.id.toString().padLeft(4, '0')}',
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12, letterSpacing: 1.5),
              ),
              const SizedBox(height: 4),
              Text(
                pokemon.capitalizedName,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: pokemon.types.map((t) => TypeBadge(type: t)).toList(),
              ),
              const SizedBox(height: 8),
              RoleBadge(role: pokemon.combatRole),
            ],
          ),
        ),
      ],
    );
  }
}
