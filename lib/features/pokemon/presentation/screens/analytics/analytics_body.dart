import 'package:flutter/material.dart';
import '../../../domain/entities/pokemon_entity.dart';
import '../../widgets/stats_radar_chart.dart';
import '../../widgets/tcp_bar_chart.dart';
import '../../widgets/glass_card.dart';
import '../head_to_head_screen.dart';
import 'widgets/analytics_header.dart';
import 'widgets/tcp_card.dart';
import 'widgets/bias_card.dart';
import 'widgets/measurements_card.dart';
import '../../../../../../core/theme/app_theme.dart';

class AnalyticsBody extends StatelessWidget {
  final PokemonEntity pokemon;

  const AnalyticsBody({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.typeColors[pokemon.primaryType] ?? AppTheme.accent;

    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows, color: AppTheme.accent),
            tooltip: 'Compare',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HeadToHeadScreen(initialPokemonA: pokemon),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AnalyticsHeader(pokemon: pokemon, accentColor: accent),
          ),
          SliverToBoxAdapter(
            child: TcpCard(pokemon: pokemon, accentColor: accent),
          ),
          SliverToBoxAdapter(
            child: BiasCard(pokemon: pokemon, accentColor: accent),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GlassCard(
                accentColor: accent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'STAT DISTRIBUTION',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    StatsRadarChart(pokemon: pokemon, accentColor: accent),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GlassCard(
                accentColor: accent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'COMBAT POWER BREAKDOWN',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TcpBarChart(pokemon: pokemon, accentColor: accent),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: MeasurementsCard(pokemon: pokemon, accentColor: accent),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
