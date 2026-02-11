import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().initializeNotifications();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "ISI_DARI_FIREBASE",
      appId: "ISI_DARI_FIREBASE",
      messagingSenderId: "ISI_DARI_FIREBASE",
      projectId: "omega-baton-480411-i2",
      databaseURL:
          "https://omega-baton-480411-i2-default-rtdb.asia-southeast1.firebasedatabase.app",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashPage(), // 👈 INI KUNCINYA
    );
  }
}
