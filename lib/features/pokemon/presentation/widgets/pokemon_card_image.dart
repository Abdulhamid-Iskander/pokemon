import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/pokemon_entity.dart';
import 'shimmer/shimmer_container.dart';

class PokemonCardImage extends StatelessWidget {
  final PokemonEntity pokemon;
  final Color accentColor;

  const PokemonCardImage({
    super.key,
    required this.pokemon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'pokemon-${pokemon.id}',
      child: Container(
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [accentColor.withOpacity(0.15), Colors.transparent],
          ),
        ),
        child: pokemon.imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: pokemon.imageUrl,
                fit: BoxFit.contain,
                placeholder: (_, __) => const Center(
                  child: ShimmerContainer(width: 80, height: 80, borderRadius: 40),
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.catching_pokemon, size: 50, color: Colors.white24),
              )
            : const Icon(Icons.catching_pokemon, size: 50, color: Colors.white24),
      ),
    );
  }
}
