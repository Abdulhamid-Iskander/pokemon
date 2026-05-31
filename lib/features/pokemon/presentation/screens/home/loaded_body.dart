import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';
import '../../widgets/hero_banner.dart';
import '../../widgets/floating_search_bar.dart';
import '../../widgets/shimmer/pulsing_dot.dart';
import '../../widgets/shimmer/shimmer_loading_card.dart';
import '../head_to_head_screen.dart';
import 'pokemon_grid.dart';
import 'widgets/filters_section.dart';
import '../../../../../../core/theme/app_theme.dart';

class LoadedBody extends StatelessWidget {
  final HomeLoaded state;

  const LoadedBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppTheme.background.withOpacity(0.95),
          floating: true,
          snap: true,
          elevation: 0,
          title: const Row(
            children: [
              Icon(Icons.catching_pokemon, color: AppTheme.accent, size: 22),
              SizedBox(width: 8),
              Text(
                'COMBAT ANALYTICS',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.compare_arrows, color: AppTheme.accent),
              tooltip: 'Head-to-Head',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HeadToHeadScreen()),
              ),
            ),
          ],
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        if (state.heroPokemon != null)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'TOP FIGHTER',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                HeroBanner(hero: state.heroPokemon!),
              ],
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: FloatingSearchBar(
              onChanged: (q) => context.read<HomeCubit>().onSearchChanged(q),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: FiltersSection(state: state),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FIGHTERS (${(state.selectedType != null || state.selectedRole != null) ? (state.dashboardDetails.where((p) {
                      final matchesType = state.selectedType == null || p.types.contains(state.selectedType);
                      final matchesRole = state.selectedRole == null || p.combatRole == state.selectedRole;
                      return matchesType && matchesRole;
                    }).length) : state.filteredPokemon.length})',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (state.isLoadingDashboard)
                  const PulsingDot(
                    color: AppTheme.accent,
                    size: 10.0,
                  ),
              ],
            ),
          ),
        ),
        if (state.isLoadingDashboard && state.dashboardDetails.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, i) => const ShimmerCard(),
                childCount: 10,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
            ),
          )
        else
          PokemonGrid(
            allItems: state.filteredPokemon,
            loadedDetails: state.dashboardDetails,
            selectedType: state.selectedType,
            selectedRole: state.selectedRole,
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
