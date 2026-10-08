import 'package:flutter/material.dart';
import 'package:odotrack/modules/service/add_service_page.dart';

class ServiceHistoryPage extends StatelessWidget {
  const ServiceHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            // TODO: Back action
          },
        ),
        title: const Text(
          'Riwayat Servis',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        children: [
          // Banner Estimasi Servis
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF), // Light purple background
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_month, color: Color(0xFF6C4DFF)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Estimasi Servis Berikutnya',
                        style: TextStyle(
                          color: Color(0xFF6C4DFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Berdasarkan riwayat, servis disarankan pada 12 Nov 2026 atau pada 14.450 km.',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // List Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Semua Riwayat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Filter',
                style: TextStyle(color: Color(0xFF6C4DFF), fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // List Items (Before -> dipisah jadi widget)
          const ServiceCard(
            title: 'Servis Ringan',
            date: '12 Agu 2026',
            cost: 'Rp250.000',
            kilometer: '12.450 km',
            icon: Icons.build_outlined,
          ),
          const SizedBox(height: 12),
          const ServiceCard(
            title: 'Ganti Oli + Filter',
            date: '15 Mei 2026',
            cost: 'Rp180.000',
            kilometer: '10.100 km',
            icon: Icons.oil_barrel_outlined,
          ),
          const SizedBox(height: 12),
          const ServiceCard(
            title: 'Ganti Kampas Rem',
            date: '10 Feb 2026',
            cost: 'Rp120.000',
            kilometer: '6.500 km',
            icon: Icons.settings_outlined,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddServicePage()),
          );
        },
        backgroundColor: const Color(0xFF6C4DFF),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

// Widget Card yang di-extract
class ServiceCard extends StatelessWidget {
  final String title;
  final String date;
  final String cost;
  final String kilometer;
  final IconData icon;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.date,
    required this.cost,
    required this.kilometer,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF6C4DFF), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                cost,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                kilometer,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
