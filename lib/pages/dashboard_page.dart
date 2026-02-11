import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../models/sensor_data.dart';
import '../widgets/sensor_card.dart';

class DashboardPage extends StatelessWidget {
  final List<SensorData> data;
  const DashboardPage(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final d = data.first;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        child: VStack([
          // ===== Header =====
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: VStack([
              "Realtime Condition".text.xl3.bold
                  .color(colorScheme.onBackground)
                  .make(),

              "Live monitoring".text.sm
                  .color(colorScheme.onBackground.withOpacity(0.6))
                  .make(),
            ]),
          ),

          25.heightBox,

          // ===== Grid Sensor =====
          GridView.count(
            crossAxisCount: context.isMobile ? 2 : 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SensorCard(
                icon: Icons.thermostat,
                label: "Suhu",
                value: "${d.temperature}°C",
                iconColor: Colors.red,
                background: Colors.grey.shade300,
              ),
              SensorCard(
                icon: Icons.water_drop,
                label: "Kelembaban",
                value: "${d.humidity}%",
                iconColor: Colors.blue,
                background: Colors.grey.shade300,
              ),
              SensorCard(
                icon: Icons.lightbulb,
                label: "Cahaya",
                value: "${d.light}",
                iconColor: Colors.yellow,
                background: Colors.grey.shade300,
              ),
              SensorCard(
                icon: Icons.graphic_eq,
                label: "Suara",
                value: "${d.sound}",
                iconColor: Colors.purple,
                background: Colors.grey.shade300,
              ),
              SensorCard(
                icon: Icons.star,
                label: "Skor",
                value: "${d.score}",
                iconColor: Colors.orange,
                background: Colors.grey.shade300,
              ),
              SensorCard(
                icon: Icons.bedtime,
                label: "Kondisi",
                value: d.sleepQuality,
                iconColor: Colors.green,
                background: Colors.grey.shade300,
              ),
            ],
          ),
        ]).p16(),
      ),
    );
  }
}
