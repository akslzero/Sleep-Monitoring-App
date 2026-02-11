import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/sensor_data.dart';
import '../services/notification_service.dart';
import 'dashboard_page.dart';
import 'chart_page.dart';
import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final dbRef = FirebaseDatabase.instance.ref("data/sensor");
  List<SensorData> data = [];
  String? lastQuality;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _listenToSensorData();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initializeNotifications();
  }

  void _listenToSensorData() {
    dbRef.onValue.listen((event) {
      final raw = event.snapshot.value;
      if (raw is Map) {
        final list = raw.values.map((e) {
          final m = e as Map;
          print('DEBUG MAP: $m');

          DateTime parsedTime = DateTime.now();

          var ts = m['timestamp'] ?? m['time'] ?? m['createdAt'] ?? m['date'];

          if (ts != null) {
            try {
              if (ts is String) {
                parsedTime = DateTime.parse(ts);
              } else if (ts is int) {
                // cek apakah ts detik atau millisecond
                if (ts < 10000000000) {
                  // kemungkinan detik
                  parsedTime = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
                } else {
                  parsedTime = DateTime.fromMillisecondsSinceEpoch(ts);
                }
              } else if (ts is double) {
                if (ts < 10000000000) {
                  parsedTime = DateTime.fromMillisecondsSinceEpoch(
                    (ts * 1000).toInt(),
                  );
                } else {
                  parsedTime = DateTime.fromMillisecondsSinceEpoch(ts.toInt());
                }
              }
            } catch (e) {
              print('PARSE ERROR: $e');
              parsedTime = DateTime.now();
            }
          } else {
            print('DEBUG: Timestamp field not found!');
          }

          return SensorData(
            time: parsedTime,
            temperature: (m['temperature'] as num?)?.toDouble() ?? 0,
            humidity: (m['humidity'] as num?)?.toDouble() ?? 0,
            light: (m['light'] as num?)?.toInt() ?? 0,
            sound: (m['sound'] as num?)?.toInt() ?? 0,
            score: (m['score'] as num?)?.toInt() ?? 0,
            sleepQuality: m['quality'] ?? "-",
          );
        }).toList()..sort((a, b) => b.time.compareTo(a.time));

        // Deteksi perubahan kualitas tidur
        if (list.isNotEmpty) {
          final currentQuality = list[0].sleepQuality;
          final currentScore = list[0].score;

          print(
            'DEBUG QUALITY: lastQuality=$lastQuality, currentQuality=$currentQuality',
          );

          // Jika ada perubahan kualitas dari sebelumnya
          if (lastQuality != null && lastQuality != currentQuality) {
            print('DEBUG: Sending notification for quality: $currentQuality');
            _notificationService.showQualityNotification(
              quality: currentQuality,
              score: currentScore,
            );
          }

          lastQuality = currentQuality;
        }

        setState(() => data = list);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [DashboardPage(data), ChartPage(data), HistoryPage(data)];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "Grafik",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
    );
  }
}
