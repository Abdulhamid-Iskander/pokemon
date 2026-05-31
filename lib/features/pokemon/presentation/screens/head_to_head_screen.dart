import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/head_to_head_cubit.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../widgets/head_to_head_chart.dart';
import '../widgets/glass_card.dart';
import '../widgets/shimmer/pulsing_pokeball_loader.dart';
import 'head_to_head/fighter_slot.dart';
import 'head_to_head/winner_card.dart';
import 'head_to_head/stat_diff_table.dart';
import '../../../../../core/theme/app_theme.dart';

class HeadToHeadScreen extends StatelessWidget {
  final PokemonEntity? initialPokemonA;
  const HeadToHeadScreen({super.key, this.initialPokemonA});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = HeadToHeadCubit();
        if (initialPokemonA != null) {
          cubit.emit(H2HLoaded(pokemonA: initialPokemonA));
        }
        return cubit;
      },
      child: const _H2HView(),
    );
  }
}

class _H2HView extends StatelessWidget {
  const _H2HView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('HEAD-TO-HEAD', style: TextStyle(letterSpacing: 2, fontSize: 15)),
        centerTitle: true,
      ),
      body: BlocBuilder<HeadToHeadCubit, HeadToHeadState>(
        builder: (context, state) {
          if (state is H2HLoading) {
            return const Center(child: PulsingPokeballLoader(label: 'Retrieving battle simulation data...'));
          }

          final loaded = state is H2HLoaded ? state : H2HLoaded();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FighterSlot(pokemon: loaded.pokemonA, label: 'FIGHTER A', isA: true, accentColor: AppTheme.accent),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text('VS', style: TextStyle(color: AppTheme.accentSecondary, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ),
                    Expanded(
                      child: FighterSlot(pokemon: loaded.pokemonB, label: 'FIGHTER B', isA: false, accentColor: AppTheme.accentSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (loaded.winner != null) WinnerCard(winner: loaded.winner!),
                const SizedBox(height: 16),
                if (loaded.pokemonA != null && loaded.pokemonB != null)
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _legendDot(AppTheme.accent),
                            const SizedBox(width: 6),
                            Text(loaded.pokemonA!.capitalizedName, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                            const SizedBox(width: 16),
                            _legendDot(AppTheme.accentSecondary),
                            const SizedBox(width: 6),
                            Text(loaded.pokemonB!.capitalizedName, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        HeadToHeadChart(pokemonA: loaded.pokemonA!, pokemonB: loaded.pokemonB!, colorA: AppTheme.accent, colorB: AppTheme.accentSecondary),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                if (loaded.statDiff != null) StatDiffTable(diff: loaded.statDiff!, pokemonA: loaded.pokemonA!, pokemonB: loaded.pokemonB!),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _legendDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
