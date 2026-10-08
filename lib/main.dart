import 'package:flutter/material.dart';
import 'package:odotrack/modules/service/service_history_page.dart';
// import 'package:odotrack/modules/dashboard/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan tulisan "DEBUG"
      title: 'OdoTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const ServiceHistoryPage(), // Dikembalikan ke halamannya Firza
    );
  }
}
