import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


Widget myLineChart(dynamic homeController) {
    return LineChart(
      LineChartData(
          lineBarsData: [
            LineChartBarData(
              show: true,
              spots: homeController.allAvg
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              color: Colors.red,
              isCurved: true,
              barWidth: 6,
              curveSmoothness: 0.3,
              isStrokeCapRound: true,
            ),
            LineChartBarData(
              show: true,
              spots: homeController.allDistanse
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              color: Colors.blue,
              isCurved: true,
              barWidth: 6,
              curveSmoothness: 0.3,
              isStrokeCapRound: true,
            ),
          ],
          titlesData: FlTitlesData(
            show: false,
          ),
          gridData: FlGridData(
            show: false,
          ),
          borderData: FlBorderData(
            show: false,
          )),
    );
  }