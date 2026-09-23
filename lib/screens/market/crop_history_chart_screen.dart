import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';
import '../../models/crop_model.dart';
import '../../widgets/price_table.dart';

class CropHistoryChartScreen extends StatelessWidget {
  final CropRate crop;

  const CropHistoryChartScreen({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    final history = crop.history;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              '${crop.displayName} - Last 7 Days',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Prices for 20 Kg',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 7-day data table
              PriceTable(records: history),
              const SizedBox(height: 32),

              // Multi-line chart (Page 14)
              SizedBox(
                height: 260,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 6,
                    minY: 480,
                    maxY: 720,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 50,
                      getDrawingHorizontalLine: (val) => FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 50,
                          reservedSize: 36,
                          getTitlesWidget: (val, meta) {
                            if (val < 500 || val > 700) return const SizedBox.shrink();
                            return Text(
                              '${val.toInt()}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 26,
                          getTitlesWidget: (val, meta) {
                            final idx = val.toInt();
                            final dates = ['14 May', '15 May', '16 May', '17 May', '18 May', '19 May', '20 May'];
                            if (idx >= 0 && idx < dates.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  dates[idx],
                                  style: const TextStyle(fontSize: 10, color: AppColors.textLight),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      // Min Price (Green)
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 540),
                          FlSpot(1, 550),
                          FlSpot(2, 560),
                          FlSpot(3, 570),
                          FlSpot(4, 580),
                          FlSpot(5, 590),
                          FlSpot(6, 600),
                        ],
                        isCurved: false,
                        color: AppColors.primaryGreen,
                        barWidth: 2.2,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 3.5,
                            color: AppColors.primaryGreen,
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          ),
                        ),
                      ),
                      // Avg Price (Grey)
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 590),
                          FlSpot(1, 600),
                          FlSpot(2, 610),
                          FlSpot(3, 620),
                          FlSpot(4, 630),
                          FlSpot(5, 640),
                          FlSpot(6, 650),
                        ],
                        isCurved: false,
                        color: const Color(0xFF6B7280),
                        barWidth: 2.2,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 3.5,
                            color: const Color(0xFF6B7280),
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          ),
                        ),
                      ),
                      // Max Price (Blue)
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 640),
                          FlSpot(1, 650),
                          FlSpot(2, 660),
                          FlSpot(3, 670),
                          FlSpot(4, 680),
                          FlSpot(5, 690),
                          FlSpot(6, 700),
                        ],
                        isCurved: false,
                        color: const Color(0xFF2563EB),
                        barWidth: 2.2,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 3.5,
                            color: const Color(0xFF2563EB),
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Legend
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildLegendItem('Min Price', AppColors.primaryGreen),
                  _buildLegendItem('Avg Price', const Color(0xFF6B7280)),
                  _buildLegendItem('Max Price', const Color(0xFF2563EB)),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 3,
          color: color,
        ),
        const SizedBox(width: 4),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textMedium),
        ),
      ],
    );
  }
}
