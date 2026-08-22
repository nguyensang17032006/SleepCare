import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/l10n/app_localizations.dart';

class LineChartWidget extends StatefulWidget {
  final bool initialIsWeekly;
  final List<FlSpot>? weeklySpots;
  final List<FlSpot>? monthlySpots;

  const LineChartWidget({
    super.key,
    this.initialIsWeekly = true,
    this.weeklySpots,
    this.monthlySpots,
  });

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late bool isWeekly;

  @override
  void initState() {
    super.initState();
    isWeekly = widget.initialIsWeekly;
  }

  bool get _hasData {
    final spots = isWeekly ? widget.weeklySpots : widget.monthlySpots;
    return spots != null && spots.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.reportSleepQualityIndex,
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.cardLightColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isWeekly = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isWeekly
                            ? AppTheme.primaryColor.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l10n.reportWeekly,
                        style: TextStyle(
                          color: isWeekly
                              ? AppTheme.primaryColor
                              : AppTheme.textMuted,
                          fontSize: 10,
                          fontWeight: isWeekly
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isWeekly = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: !isWeekly
                            ? AppTheme.primaryColor.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l10n.reportMonthly,
                        style: TextStyle(
                          color: !isWeekly
                              ? AppTheme.primaryColor
                              : AppTheme.textMuted,
                          fontSize: 10,
                          fontWeight: !isWeekly
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardLightColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: 120,
            child: _hasData
                ? _buildLineChart(l10n)
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.insights_rounded,
                          color: AppTheme.textMuted.withValues(alpha: 0.4),
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.reportNoData,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart(AppLocalizations l10n) {
    return LineChart(
      key: ValueKey(isWeekly),
      LineChartData(
        minY: 0,
        maxY: 10,
        minX: isWeekly ? 0 : 1,
        maxX: isWeekly ? 6 : 4,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                );
                String text;
                if (isWeekly) {
                  switch (value.toInt()) {
                    case 0:
                      text = l10n.dayMon;
                      break;
                    case 1:
                      text = l10n.dayTue;
                      break;
                    case 2:
                      text = l10n.dayWed;
                      break;
                    case 3:
                      text = l10n.dayThu;
                      break;
                    case 4:
                      text = l10n.dayFri;
                      break;
                    case 5:
                      text = l10n.daySat;
                      break;
                    case 6:
                      text = l10n.daySun;
                      break;
                    default:
                      text = '';
                      break;
                  }
                } else {
                  switch (value.toInt()) {
                    case 1:
                      text = l10n.week1;
                      break;
                    case 2:
                      text = l10n.week2;
                      break;
                    case 3:
                      text = l10n.week3;
                      break;
                    case 4:
                      text = l10n.week4;
                      break;
                    default:
                      text = '';
                      break;
                  }
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
        lineBarsData: [
          LineChartBarData(
            spots: (isWeekly ? widget.weeklySpots : widget.monthlySpots) ?? [],
            isCurved: true,
            color: AppTheme.primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
