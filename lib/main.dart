import 'package:flutter/material.dart';
import 'package:odotrack/modules/vehicle/vehicle_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OdoTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B61FF)),
        fontFamily: 'Inter', // Assuming Inter or similar is used, flutter will fall back if not in pubspec
        useMaterial3: true,
      ),
      home: const VehicleListPage(),
    );
  }
}
