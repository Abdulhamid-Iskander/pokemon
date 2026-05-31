import 'package:flutter/material.dart';
import '../../../../domain/entities/pokemon_entity.dart';
import '../../data/models/pokemon_list_item_model.dart';
import '../../widgets/pokemon_card.dart';
import '../../../../../core/theme/app_theme.dart';

class PokemonGrid extends StatelessWidget {
  final List<PokemonListItemModel> allItems;
  final List<PokemonEntity> loadedDetails;
  final String? selectedType;
  final String? selectedRole;

  const PokemonGrid({
    super.key,
    required this.allItems,
    required this.loadedDetails,
    this.selectedType,
    this.selectedRole,
  });

  @override
  Widget build(BuildContext context) {
    final detailMap = {for (final d in loadedDetails) d.name: d};

    List<PokemonEntity> filtered = loadedDetails;
    if (selectedType != null) {
      filtered = filtered.where((p) => p.types.contains(selectedType)).toList();
    }
    if (selectedRole != null) {
      filtered = filtered.where((p) => p.combatRole == selectedRole).toList();
    }

    final displayList = (selectedType != null || selectedRole != null) ? filtered : null;

    final items = displayList ??
        allItems.take(20).map((item) {
          return detailMap[item.name];
        }).whereType<PokemonEntity>().toList();

    if (items.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Text(
              'No fighters found',
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, i) {
            if (i >= items.length) return null;
            final pokemon = items[i];
            return PokemonCard(
              pokemon: pokemon,
              index: i,
              accentColor: AppTheme.typeColors[pokemon.primaryType],
            );
          },
          childCount: items.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.70,
        ),
      ),
    );
  }
}
