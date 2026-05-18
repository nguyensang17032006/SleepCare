import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('SleepCare', style: TextStyle(color: AppTheme.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppTheme.cardLightColor,
              radius: 16,
              child: Image.asset('assets/images/logo.png', width: 20, height: 20, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 16)),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('INSIGHTS ENGINE', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Your Sleep\nArchitecture', style: TextStyle(color: AppTheme.textLight, fontSize: 24, fontWeight: FontWeight.bold, height: 1.2)),
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardLightColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Average Duration', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text('7.5', style: TextStyle(color: AppTheme.textLight, fontSize: 36, fontWeight: FontWeight.bold, height: 1.0)),
                              SizedBox(width: 4),
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Text('hours', style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: const [
                              Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 12),
                              SizedBox(width: 4),
                              Text('12% more sleep than last week', style: TextStyle(color: Colors.greenAccent, fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.nightlight_round, color: AppTheme.primaryColor, size: 48),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardLightColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weekly Consistency', style: TextStyle(color: AppTheme.textLight, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 120,
                      child: _buildBarChart(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sleep Quality Index', style: TextStyle(color: AppTheme.textLight, fontSize: 18, fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.cardLightColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                          child: const Text('Weekly', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 4),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Text('Monthly', style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Monthly trend analysis', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardLightColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  height: 120,
                  child: _buildLineChart(),
                ),
              ),
              const SizedBox(height: 30),
              
              const Text('PILLOW TALK', style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildInsightCard(Icons.lightbulb_outline, 'Nightly Rhythms', 'Your sleep latency was noticeably improved by 15% during REM cycles. Some evening deep tones worked well for you last month.'),
              const SizedBox(height: 12),
              _buildInsightCard(Icons.star_outline, 'Pillow Talk', 'Consistency is key. Your 10:30 PM bed time is becoming a normal routine for your circadian body.'),
              const SizedBox(height: 30),
              
              PrimaryButton(
                text: 'Generate Full PDF Report',
                onPressed: () {},
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.cardLightColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppTheme.textLight, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12, height: 1.5)),
              ],
            ),
          ),
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
                const style = TextStyle(color: AppTheme.textMuted, fontSize: 10);
                String text;
                switch (value.toInt()) {
                  case 0: text = 'MON'; break;
                  case 1: text = 'TUE'; break;
                  case 2: text = 'WED'; break;
                  case 3: text = 'THU'; break;
                  case 4: text = 'FRI'; break;
                  case 5: text = 'SAT'; break;
                  case 6: text = 'SUN'; break;
                  default: text = ''; break;
                }
                return Padding(padding: const EdgeInsets.only(top: 8), child: Text(text, style: style));
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
          color: isHighlight ? AppTheme.primaryColor : AppTheme.textMuted.withOpacity(0.3),
          width: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 10,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(color: AppTheme.textMuted, fontSize: 10);
                String text;
                switch (value.toInt()) {
                  case 1: text = 'WEEK 1'; break;
                  case 3: text = 'WEEK 2'; break;
                  case 5: text = 'WEEK 3'; break;
                  case 7: text = 'WEEK 4'; break;
                  default: text = ''; break;
                }
                return Padding(padding: const EdgeInsets.only(top: 8), child: Text(text, style: style));
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
            spots: const [
              FlSpot(0, 4),
              FlSpot(1, 5),
              FlSpot(2, 4.5),
              FlSpot(3, 6),
              FlSpot(4, 5.5),
              FlSpot(5, 7.5),
              FlSpot(6, 7),
              FlSpot(7, 8.5),
              FlSpot(8, 8),
            ],
            isCurved: true,
            color: AppTheme.primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryColor.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
