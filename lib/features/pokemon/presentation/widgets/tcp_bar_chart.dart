import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../../../../core/theme/app_theme.dart';

class TcpBarChart extends StatefulWidget {
  final PokemonEntity pokemon;
  final Color accentColor;

  const TcpBarChart({
    super.key,
    required this.pokemon,
    required this.accentColor,
  });

  @override
  State<TcpBarChart> createState() => _TcpBarChartState();
}

class _TcpBarChartState extends State<TcpBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _animation = CurvedAnimation(
        parent: _controller, curve: Curves.easeOutCubic);
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

    final maxAtk = p.attack > p.spAtk ? p.attack : p.spAtk;
    final atkContrib = maxAtk * 1.5;
    final spdContrib = p.speed * 1.2;
    final bulkContrib = (p.hp * p.defense) / 100.0;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (atkContrib + 50) * 1.2,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const labels = [
                        'ATK\nContrib',
                        'SPD\nContrib',
                        'BULK\nContrib',
                      ];
                      final idx = value.toInt();
                      if (idx >= 0 && idx < labels.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            labels[idx],
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
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
              barGroups: [
                _bar(0, atkContrib * _animation.value,
                    color.withOpacity(0.9)),
                _bar(1, spdContrib * _animation.value,
                    AppTheme.accentSecondary.withOpacity(0.9)),
                _bar(2, bulkContrib * _animation.value,
                    Colors.teal.withOpacity(0.9)),
              ],
            ),
          ),
        );
      },
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 28,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 300,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }
}
