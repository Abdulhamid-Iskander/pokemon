import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/detail_cubit.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../widgets/shimmer/pulsing_pokeball_loader.dart';
import 'analytics/analytics_body.dart';
import '../../../../../core/theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  final String pokemonName;
  final PokemonEntity? initialEntity;

  const AnalyticsScreen({
    super.key,
    required this.pokemonName,
    this.initialEntity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = DetailCubit();
        if (initialEntity != null) {
          cubit.emit(DetailLoaded(initialEntity!));
        } else {
          cubit.loadPokemon(pokemonName);
        }
        return cubit;
      },
      child: const _AnalyticsView(),
    );
  }
}

class _AnalyticsView extends StatelessWidget {
  const _AnalyticsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailCubit, DetailState>(
      builder: (context, state) {
        if (state is DetailLoading) {
          return const Scaffold(
            backgroundColor: AppTheme.background,
            body: Center(
              child: PulsingPokeballLoader(
                label: 'Analyzing stats and combat power...',
              ),
            ),
          );
        }

        if (state is DetailError) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(),
            body: Center(
              child: Text(state.message, style: const TextStyle(color: AppTheme.textSecondary)),
            ),
          );
        }

        if (state is DetailLoaded) {
          return AnalyticsBody(pokemon: state.pokemon);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
