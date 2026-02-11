import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/sensor_data.dart';

class ChartPage extends StatelessWidget {
  final List<SensorData> data;
  const ChartPage(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: VStack([
          "Grafik Realtime".text.xl2.bold.make().pOnly(top: 12),

          24.heightBox,

          _chartCard(
            icon: Icons.thermostat,
            title: "Suhu (°C)",
            color: Colors.red,
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.temperature))
                .toList(),
          ),

          20.heightBox,

          _chartCard(
            icon: Icons.water_drop,
            title: "Kelembaban (%)",
            color: Colors.blue,
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.humidity))
                .toList(),
          ),

          20.heightBox,

          _chartCard(
            icon: Icons.lightbulb,
            title: "Cahaya",
            color: Colors.orange.shade600,

            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.light.toDouble()))
                .toList(),
          ),

          20.heightBox,

          _chartCard(
            icon: Icons.graphic_eq,
            title: "Suara",
            color: Colors.purple,
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.sound.toDouble()))
                .toList(),
          ),
        ]),
      ),
    );
  }

  Widget _chartCard({
    required IconData icon,
    required String title,
    required Color color,
    required List<FlSpot> spots,
  }) {
    return VStack([
      // ===== Header =====
      HStack([Icon(icon, color: color), 8.widthBox, title.text.lg.bold.make()]),

      12.heightBox,

      SizedBox(
        height: 220,
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.white10,
            minX: 0,
            maxX: spots.isNotEmpty ? spots.last.x : 0,

            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 5,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: Colors.white.withOpacity(0.15), strokeWidth: 1),
            ),

            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),

            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) =>
                      value.toInt().text.sm.make(),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (spots.length / 4).ceilToDouble(),
                  getTitlesWidget: (value, meta) =>
                      value.toInt().text.xs.make(),
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: color,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.35), color.withOpacity(0.05)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]).box.color(Colors.white).p16.roundedLg.shadowSm.make();
  }
}
