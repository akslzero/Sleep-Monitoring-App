class SensorData {
  final DateTime time;
  final double temperature;
  final double humidity;
  final int light;
  final int sound;
  final int score;
  final String sleepQuality;

  SensorData({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.sound,
    required this.score,
    required this.sleepQuality,
  });
}
