import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  final List data;
  const ChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map(
                  (e) => FlSpot(
                    e.key.toDouble(),
                    (e.value['sales'] as num).toDouble(),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
