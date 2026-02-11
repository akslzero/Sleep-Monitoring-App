import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../models/sensor_data.dart';
import '../utils/helpers.dart';

class HistoryPage extends StatelessWidget {
  final List<SensorData> data;
  const HistoryPage(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const CircularProgressIndicator().centered();
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: VStack([
            "History Condition".text.xl2.bold.make().pOnly(bottom: 24),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, i) {
                final d = data[i];
                final color = getQualityColor(d.sleepQuality);

                return Column(
                  children: [
                    HStack([
                      Icon(Icons.history, color: color),

                      12.widthBox,

                      VStack([
                        d.time.toString().split('.').first.text.bold.make(),
                        "T:${d.temperature}°C | H:${d.humidity}% | L:${d.light} | S:${d.sound}"
                            .text
                            .sm
                            .gray500
                            .make(),
                      ]).expand(),

                      d.sleepQuality.text.sm
                          .color(color.withOpacity(.8))
                          .make(),
                    ]).p(12).box.roundedLg.shadowSm.white.make(),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
