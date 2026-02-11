import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  int index = 0;

  final pages = const [
    {
      "icon": Icons.sensors,
      "title": "Realtime Monitoring Condition & Quality",
      "desc": "Pantau kondisi kualitas tidur secara langsung dari aplikasi",
    },
    {
      "icon": Icons.show_chart,
      "title": "Grafik Pintar & Histori realtime",
      "desc": "Lihat perubahan data secara realitime",
    },
    {
      "icon": Icons.notifications,
      "title": "Notifikasi Otomatis",
      "desc": "Dapatkan info perubahan kondisi & kualitas tidur secara otomatis",
    },
  ];

  Future<void> finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seen_onboarding", true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VStack([
        Expanded(
          child: PageView.builder(
            controller: controller,
            itemCount: pages.length,
            onPageChanged: (i) => setState(() => index = i),
            itemBuilder: (_, i) {
              final p = pages[i];
              return VStack([
                Icon(p["icon"] as IconData, size: 120),
                24.heightBox,
                (p["title"] as String).text.xl.bold.make(),
                12.heightBox,
                (p["desc"] as String).text.center.gray500.make(),
              ]).centered();
            },
          ),
        ),

        HStack([
          if (index < pages.length - 1) "Lewati".text.make().onTap(finish),

          const Spacer(),

          ElevatedButton(
            onPressed: () {
              if (index == pages.length - 1) {
                finish();
              } else {
                controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }
            },
            child: Text(index == pages.length - 1 ? "Mulai" : "Lanjut"),
          ),
        ]).p16(),
      ]),
    );
  }
}
