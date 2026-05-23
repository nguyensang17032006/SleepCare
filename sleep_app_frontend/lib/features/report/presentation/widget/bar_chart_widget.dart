import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardLightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Consistency',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(height: 120, child: _buildBarChart()),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                );
                String text;
                switch (value.toInt()) {
                  case 0:
                    text = 'MON';
                    break;
                  case 1:
                    text = 'TUE';
                    break;
                  case 2:
                    text = 'WED';
                    break;
                  case 3:
                    text = 'THU';
                    break;
                  case 4:
                    text = 'FRI';
                    break;
                  case 5:
                    text = 'SAT';
                    break;
                  case 6:
                    text = 'SUN';
                    break;
                  default:
                    text = '';
                    break;
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(text, style: style),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          _makeBarData(0, 6, false),
          _makeBarData(1, 7, false),
          _makeBarData(2, 5, false),
          _makeBarData(3, 8, true),
          _makeBarData(4, 7.5, false),
          _makeBarData(5, 6.5, false),
          _makeBarData(6, 9, false),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarData(int x, double y, bool isHighlight) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isHighlight
              ? AppTheme.primaryColor
              : AppTheme.textMuted.withValues(alpha: 0.3),
          width: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
