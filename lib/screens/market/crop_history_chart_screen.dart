import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../resources/resources.dart';
import '../../models/crop_model.dart';
import '../../widgets/price_table.dart';

// 7-day crop price trend chart and history table
class CropHistoryChartScreen extends StatelessWidget {
  final CropRate crop;

  const CropHistoryChartScreen({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    final history = crop.history;
    final reversedHistory = history.reversed.toList();

    int minVal = 999999;
    int maxVal = 0;
    for (final r in reversedHistory) {
      if (r.minPrice < minVal) minVal = r.minPrice;
      if (r.maxPrice > maxVal) maxVal = r.maxPrice;
    }
    if (minVal == 999999) minVal = 500;
    if (maxVal == 0) maxVal = 700;

    final double chartMinY = ((minVal / 50).floor() * 50 - 40).toDouble().clamp(0, double.infinity);
    final double chartMaxY = ((maxVal / 50).ceil() * 50 + 40).toDouble();
    final double interval = ((chartMaxY - chartMinY) / 4).roundToDouble().clamp(20, 200);

    final minSpots = <FlSpot>[];
    final avgSpots = <FlSpot>[];
    final maxSpots = <FlSpot>[];
    final dates = <String>[];

    for (int i = 0; i < reversedHistory.length; i++) {
      final rec = reversedHistory[i];
      minSpots.add(FlSpot(i.toDouble(), rec.minPrice.toDouble()));
      avgSpots.add(FlSpot(i.toDouble(), rec.avgPrice.toDouble()));
      maxSpots.add(FlSpot(i.toDouble(), rec.maxPrice.toDouble()));
      final parts = rec.date.split(' ');
      dates.add(parts.length >= 2 ? '${parts[0]} ${parts[1]}' : rec.date);
    }

    final double maxX = (reversedHistory.length - 1).toDouble().clamp(1, double.infinity);

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
              PriceTable(records: history),
              const SizedBox(height: 32),

              SizedBox(
                height: 260,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: maxX,
                    minY: chartMinY,
                    maxY: chartMaxY,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: interval,
                      getDrawingHorizontalLine: (val) => FlLine(
                        color: AppColors.chartGridLine,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: interval,
                          reservedSize: 42,
                          getTitlesWidget: (val, meta) {
                            if (val < chartMinY || val > chartMaxY) return const SizedBox.shrink();
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
                      LineChartBarData(
                        spots: minSpots,
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
                      LineChartBarData(
                        spots: avgSpots,
                        isCurved: false,
                        color: AppColors.chartAvgPrice,
                        barWidth: 2.2,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 3.5,
                            color: AppColors.chartAvgPrice,
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          ),
                        ),
                      ),
                      LineChartBarData(
                        spots: maxSpots,
                        isCurved: false,
                        color: AppColors.chartMaxPrice,
                        barWidth: 2.2,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 3.5,
                            color: AppColors.chartMaxPrice,
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

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildLegendItem('Min Price', AppColors.primaryGreen),
                    _buildLegendItem('Avg Price', AppColors.chartAvgPrice),
                    _buildLegendItem('Max Price', AppColors.chartMaxPrice),
                  ],
                ),
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
      mainAxisSize: MainAxisSize.min,
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
