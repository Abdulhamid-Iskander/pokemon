import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../../../../core/theme/app_theme.dart';

class StatsRadarChart extends StatefulWidget {
  final PokemonEntity pokemon;
  final Color accentColor;

  const StatsRadarChart({
    super.key,
    required this.pokemon,
    required this.accentColor,
  });

  @override
  State<StatsRadarChart> createState() => _StatsRadarChartState();
}

class _StatsRadarChartState extends State<StatsRadarChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pokemon;
    final color = widget.accentColor;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(
              height: 220,
              child: RadarChart(
                RadarChartData(
                  radarShape: RadarShape.polygon,
                  tickCount: 4,
                  ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
                  gridBorderData: const BorderSide(color: Colors.white12, width: 1),
                  radarBorderData: const BorderSide(color: Colors.white24, width: 1),
                  titlePositionPercentageOffset: 0.2,
                  titleTextStyle: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  getTitle: (index, angle) {
                    const labels = ['HP', 'ATK', 'DEF', 'SP.ATK', 'SP.DEF', 'SPD'];
                    return RadarChartTitle(text: labels[index % labels.length]);
                  },
                  dataSets: [
                    RadarDataSet(
                      fillColor: color.withOpacity(0.2 * _animation.value),
                      borderColor: color.withOpacity(_animation.value),
                      borderWidth: 2,
                      entryRadius: 3,
                      dataEntries: [
                        RadarEntry(value: p.hp * _animation.value),
                        RadarEntry(value: p.attack * _animation.value),
                        RadarEntry(value: p.defense * _animation.value),
                        RadarEntry(value: p.spAtk * _animation.value),
                        RadarEntry(value: p.spDef * _animation.value),
                        RadarEntry(value: p.speed * _animation.value),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...[
              ('HP', p.hp, Colors.green),
              ('Attack', p.attack, Colors.red),
              ('Defense', p.defense, Colors.blue),
              ('Sp. Atk', p.spAtk, Colors.purple),
              ('Sp. Def', p.spDef, Colors.indigo),
              ('Speed', p.speed, Colors.orange),
            ].map((entry) => _statRow(entry.$1, entry.$2, entry.$3)),
          ],
        );
      },
    );
  }

  Widget _statRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ),
          SizedBox(
            width: 32,
            child: Text(
              value.toString(),
              style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (_, __) => ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (value / 255.0) * _animation.value,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
