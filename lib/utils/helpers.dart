import 'package:flutter/material.dart';

Color getQualityColor(String quality) {
  switch (quality.toLowerCase()) {
    case 'nyaman':
      return Colors.green;
    case 'baik':
      return Colors.lightGreen;
    case 'cukup':
      return Colors.orange;
    case 'kurang':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
