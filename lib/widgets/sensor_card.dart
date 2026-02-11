import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SensorCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color background;

  const SensorCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return VStack([
      Icon(icon, size: 32, color: iconColor),

      12.heightBox,

      label.text.sm.color(Colors.grey.shade600).make(),

      value.text.xl.bold.make(),
    ]).box.p16.roundedLg.color(background).make();
  }
}
