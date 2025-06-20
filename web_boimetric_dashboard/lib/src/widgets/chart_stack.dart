import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../controllers/biometric_controller.dart';
import '../models/biometric_data.dart';

class ChartStack extends StatefulWidget {
  final String title;
  final Color color;
  final bool showRollingAverage;
  final bool showBands;
  final bool showMarkers;
  final double? minY;
  final double? maxY;
  final String? yAxisLabel;
  final double Function(BiometricDataPoint) valueExtractor;
  final String Function(double) valueFormatter;

  const ChartStack({
    Key? key,
    required this.title,
    this.color = Colors.blue,
    this.showRollingAverage = false,
    this.showBands = false,
    this.showMarkers = true,
    this.minY,
    this.maxY,
    this.yAxisLabel,
    required this.valueExtractor,
    required this.valueFormatter,
  }) : super(key: key);

  @override
  _ChartStackState createState() => _ChartStackState();
}

class _ChartStackState extends State<ChartStack> {

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BiometricController>();
    final data = controller.visibleData;

    if (data == null) {
      return _buildLoadingState();
    }

    final dataPoints = data.dataPoints;
    if (dataPoints.isEmpty) {
      return _buildEmptyState();
    }

    // Prepare chart data
    final spots = <FlSpot>[];
    final rollingAvgSpots = <FlSpot>[];

    final rollingAvg = data.getRollingAverage();

    for (var i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final value = widget.valueExtractor(point);

      if (!value.isNaN) {
        spots.add(FlSpot(i.toDouble(), value));

        if (widget.showRollingAverage && rollingAvg.containsKey(point.timestamp)) {
          rollingAvgSpots.add(FlSpot(i.toDouble(), rollingAvg[point.timestamp]!));
        }
      }
    }

    // Calculate Y range
    double minY = widget.minY ??
        (spots.isNotEmpty ? spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) * 0.9 : 0);
    double maxY = widget.maxY ??
        (spots.isNotEmpty ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.1 : 100);

    // Add some padding to Y range
    final yRange = maxY - minY;
    minY = (minY - yRange * 0.1).clamp(0, double.infinity);
    maxY = maxY + yRange * 0.1;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: (maxY - minY) / 4,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                      dashArray: const [4, 4],
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                      dashArray: const [4, 4],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 7,
                        getTitlesWidget: (value, meta) {
                          if (value % 7 != 0) return const SizedBox();
                          final index = value.toInt();
                          if (index < 0 || index >= dataPoints.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('MMM d').format(dataPoints[index].timestamp),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (maxY - minY) / 4,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            widget.valueFormatter(value),
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: dataPoints.isNotEmpty ? (dataPoints.length - 1).toDouble() : 10,
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    // Main data line
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: widget.color,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: widget.showMarkers,
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 3,
                          color: widget.color,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: widget.color.withOpacity(0.1),
                      ),
                    ),
                    // Rolling average line
                    if (widget.showRollingAverage && rollingAvgSpots.isNotEmpty)
                      LineChartBarData(
                        spots: rollingAvgSpots,
                        isCurved: true,
                        color: Colors.orange,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                      ),
                  ],
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.blueGrey[800]!,
                      getTooltipItems: (touchedSpots) => touchedSpots.map((touchedSpot) {
                        return LineTooltipItem(
                          '${widget.title}: ${widget.valueFormatter(touchedSpot.y)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                    touchCallback: (event, response) {
                      if (response?.lineBarSpots?.isNotEmpty ?? false) {
                        final spot = response!.lineBarSpots!.first;
                        if (spot.spotIndex < dataPoints.length) {
                          setState(() {
                            controller.selectDate(dataPoints[spot.spotIndex].timestamp);
                          });
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No data available'),
      ),
    );
  }
}
// Auto-generated comment for commit - 1763734959
// Auto-generated comment for commit - 1763734961
// Auto-generated comment for commit - 1763734961
// Auto-generated comment for commit - 1763734968
// Auto-generated comment for commit - 1763734984
// Auto-generated comment for commit - 1763734986
// Auto-generated comment for commit - 1763734992
// Auto-generated comment for commit - 1763734997
// Auto-generated comment for commit - 1763734997
// Auto-generated comment for commit - 1763734998
// Auto-generated comment for commit - 1763735042
// Auto-generated comment for commit - 1763735044
// Auto-generated comment for commit - 1763735050
// Auto-generated comment for commit - 1763735061
// Auto-generated comment for commit - 1763735062
// Auto-generated comment for commit - 1763735065
// Auto-generated comment for commit - 1763735072
// Auto-generated comment for commit - 1763735078
// Auto-generated comment for commit - 1763735082
