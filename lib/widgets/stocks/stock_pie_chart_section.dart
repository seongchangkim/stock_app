import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

PieChartSectionData StockPieChartSection(int index, double? percent, Color pieColor) {
  int touchedIndex = -1;
  final isTouched = index == touchedIndex;
  final fontSize = isTouched ? 20.0 : 12.0;
  final radius = isTouched ? 60.0 : 50.0;

  return PieChartSectionData(
    color: pieColor,
    value: percent ?? 0,
    title: '${percent ?? 0}%',
    radius: radius,
    titleStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: const Color(0xffffffff),
    ),
  );
}
