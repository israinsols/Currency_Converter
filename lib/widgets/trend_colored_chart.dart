import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class RatePoint {
  final DateTime date;
  final double value;
  RatePoint(this.date, this.value);
}

class TrendColoredChart extends StatefulWidget {
  final List<RatePoint> data;
  const TrendColoredChart({super.key, required this.data});

  @override
  State<TrendColoredChart> createState() => _TrendColoredChartState();
}

class _TrendColoredChartState extends State<TrendColoredChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: GoogleFonts.inter(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      );
    }

    final values = data.map((e) => e.value).toList();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final padding = range == 0 ? maxY * 0.1 : range * 0.15;
    final interval = range == 0 ? maxY / 4 : range / 4;

    final primaryColor = isDark ? AppColors.limeGreen : AppColors.tealDark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final mutedColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(data, primaryColor, textColor, mutedColor),
          const SizedBox(height: 20),
          _buildMinMaxRow(data, primaryColor, textColor, mutedColor),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: minY - padding,
                maxY: maxY + padding,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval == 0 ? 1 : interval,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: borderColor.withValues(alpha: 0.4),
                    strokeWidth: 0.5,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: (maxY - minY) / 4,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatValue(value),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: mutedColor,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (data.length / 5).floorToDouble().clamp(1, data.length.toDouble()),
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) return const SizedBox();
                        final d = data[idx].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${d.day} ${_monthShort(d.month)}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 12,
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        final idx = spot.x.toInt();
                        if (idx < 0 || idx >= data.length) return null;
                        final d = data[idx].date;
                        return LineTooltipItem(
                          '',
                          const TextStyle(),
                          children: [
                            TextSpan(
                              text: '${spot.y.toStringAsFixed(4)}\n',
                              style: GoogleFonts.inter(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            TextSpan(
                              text: '${d.day} ${_monthShort(d.month)} ${d.year}',
                              style: GoogleFonts.inter(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                  touchCallback: (event, response) {
                    setState(() {
                      if (event is FlLongPressEnd || event is FlPanEndEvent) {
                        _touchedIndex = -1;
                      } else if (response?.lineBarSpots != null && response!.lineBarSpots!.isNotEmpty) {
                        _touchedIndex = response.lineBarSpots!.first.spotIndex;
                      }
                    });
                  },
                  handleBuiltInTouches: true,
                  getTouchedSpotIndicator: (barData, spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: primaryColor.withValues(alpha: 0.3),
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: primaryColor,
                              strokeWidth: 3,
                              strokeColor: bgColor,
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                ),
                lineBarsData: [_buildMainLine(data, primaryColor, isDark)],
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<RatePoint> data, Color primaryColor, Color textColor, Color mutedColor) {
    final first = data.first.value;
    final last = data.last.value;
    final change = ((last - first) / first * 100);
    final isPositive = change >= 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exchange Rate',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: mutedColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.last.value.toStringAsFixed(4),
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isPositive
                ? AppColors.success.withValues(alpha: 0.15)
                : AppColors.danger.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                color: isPositive ? AppColors.success : AppColors.danger,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isPositive ? AppColors.success : AppColors.danger,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMinMaxRow(List<RatePoint> data, Color primaryColor, Color textColor, Color mutedColor) {
    final minVal = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final maxVal = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minPoint = data.firstWhere((e) => e.value == minVal);
    final maxPoint = data.firstWhere((e) => e.value == maxVal);

    return Row(
      children: [
        Expanded(
          child: _buildStatBox(
            'Low',
            minVal.toStringAsFixed(4),
            '${minPoint.date.day} ${_monthShort(minPoint.date.month)}',
            AppColors.danger,
            textColor,
            mutedColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatBox(
            'High',
            maxVal.toStringAsFixed(4),
            '${maxPoint.date.day} ${_monthShort(maxPoint.date.month)}',
            AppColors.success,
            textColor,
            mutedColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, String date, Color color, Color textColor, Color mutedColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: mutedColor,
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildMainLine(List<RatePoint> data, Color primaryColor, bool isDark) {
    final spots = List<FlSpot>.generate(
      data.length,
      (i) => FlSpot(i.toDouble(), data[i].value),
    );

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.35,
      color: primaryColor,
      barWidth: 2.5,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor.withValues(alpha: 0.25),
            primaryColor.withValues(alpha: 0.02),
          ],
        ),
      ),
    );
  }

  String _formatValue(double value) {
    if (value >= 1000) {
      return value.toStringAsFixed(0);
    } else if (value >= 100) {
      return value.toStringAsFixed(1);
    } else {
      return value.toStringAsFixed(2);
    }
  }

  String _monthShort(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}
