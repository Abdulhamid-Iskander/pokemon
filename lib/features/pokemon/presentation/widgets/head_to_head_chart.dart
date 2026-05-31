import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../../../../core/theme/app_theme.dart';

class HeadToHeadChart extends StatefulWidget {
  final PokemonEntity pokemonA;
  final PokemonEntity pokemonB;
  final Color colorA;
  final Color colorB;

  const HeadToHeadChart({
    super.key,
    required this.pokemonA,
    required this.pokemonB,
    required this.colorA,
    required this.colorB,
  });

  @override
  State<HeadToHeadChart> createState() => _HeadToHeadChartState();
}

class _HeadToHeadChartState extends State<HeadToHeadChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _anim = CurvedAnimation(
        parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.pokemonA;
    final b = widget.pokemonB;

    final statPairs = [
      ('HP', a.hp, b.hp),
      ('ATK', a.attack, b.attack),
      ('DEF', a.defense, b.defense),
      ('SP.ATK', a.spAtk, b.spAtk),
      ('SP.DEF', a.spDef, b.spDef),
      ('SPD', a.speed, b.speed),
    ];

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return SizedBox(
          height: 280,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 255,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx >= 0 && idx < statPairs.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            statPairs[idx].$1,
                            style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: Colors.white10, strokeWidth: 1),
                drawVerticalLine: false,
              ),
              barGroups: List.generate(statPairs.length, (i) {
                final pair = statPairs[i];
                return BarChartGroupData(
                  x: i,
                  groupVertically: false,
                  barRods: [
                    BarChartRodData(
                      toY: pair.$2.toDouble() * _anim.value,
                      color: widget.colorA.withOpacity(0.85),
                      width: 12,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: pair.$3.toDouble() * _anim.value,
                      color: widget.colorB.withOpacity(0.85),
                      width: 12,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
