import 'package:flutter/material.dart';
import 'models/reminder_model.dart';
import 'widgets/active_vehicle_card.dart';
import 'widgets/quick_action_button.dart';
import 'widgets/reminder_summary_card.dart';
import 'widgets/service_history_card.dart';
import 'reminder_page.dart';
import '../vehicle/vehicle_list_page.dart';
import '../vehicle/add_vehicle_page.dart';
import '../service/service_history_page.dart';
import '../service/add_service_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedBottomIndex = 0;

  // Active Vehicle State
  VehicleSummary _activeVehicle = const VehicleSummary(
    id: 'v1',
    name: 'Honda Scoopy',
    plateNumber: 'BA 4321 KZ',
    currentKm: 12450,
    type: 'Matic',
    lastServiceDate: '12 Agu 2026 (10.000 KM)',
  );

  // Reminders list (matching Figma)
  final List<ReminderModel> _reminders = [
    const ReminderModel(
      id: '1',
      title: 'Servis Berkala',
      category: 'service',
      vehicleName: 'Honda Scoopy',
      targetKm: 15000,
      currentKm: 12450,
      status: 'warning',
      description: 'Dalam 2.550 km',
      isEnabled: true,
    ),
    ReminderModel(
      id: '2',
      title: 'Pajak Kendaraan',
      category: 'tax',
      vehicleName: 'Honda Scoopy',
      dueDate: DateTime(2026, 11, 12),
      status: 'safe',
      description: '12 Nov 2026',
      isEnabled: true,
    ),
    const ReminderModel(
      id: '3',
      title: 'Ganti Oli',
      category: 'oil',
      vehicleName: 'Honda Scoopy',
      targetKm: 13000,
      currentKm: 12450,
      status: 'critical',
      description: 'Dalam 550 km',
      isEnabled: true,
    ),
  ];

  void _showUpdateKmDialog() {
    final controller =
        TextEditingController(text: _activeVehicle.currentKm.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Update Kilometer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan angka odometer terbaru di speedometer motor Anda:',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Kilometer Sekarang',
                suffixText: 'KM',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.speed),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              final newKm = int.tryParse(
                  controller.text.replaceAll(RegExp(r'[^0-9]'), ''));
              if (newKm != null && newKm >= _activeVehicle.currentKm) {
                setState(() {
                  _activeVehicle = VehicleSummary(
                    id: _activeVehicle.id,
                    name: _activeVehicle.name,
                    plateNumber: _activeVehicle.plateNumber,
                    currentKm: newKm,
                    type: _activeVehicle.type,
                    lastServiceDate: _activeVehicle.lastServiceDate,
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Kilometer berhasil diupdate menjadi $newKm KM!'),
                    backgroundColor: const Color(0xFF16A34A),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Kilometer baru tidak boleh lebih kecil dari sebelumnya.'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showSwitchVehicleModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Kendaraan Aktif',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF7C3AED),
                child: Icon(Icons.two_wheeler, color: Colors.white),
              ),
              title: const Text('Honda Scoopy',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('BA 4321 KZ • 12.450 KM'),
              trailing:
                  const Icon(Icons.check_circle, color: Color(0xFF16A34A)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.two_wheeler, color: Colors.grey),
              ),
              title: const Text('Yamaha NMAX 155',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('B 1234 ABC • 28.500 KM'),
              onTap: () {
                setState(() {
                  _activeVehicle = const VehicleSummary(
                    id: 'v2',
                    name: 'Yamaha NMAX 155',
                    plateNumber: 'B 1234 ABC',
                    currentKm: 28500,
                    type: 'Matic',
                    lastServiceDate: '01 Agu 2026 (26.000 KM)',
                  );
                });
                Navigator.pop(ctx);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_circle_outline,
                  color: Color(0xFF7C3AED)),
              title: const Text('Tambah Kendaraan Lain',
                  style: TextStyle(
                      color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddVehiclePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE9F6), // light purple background
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Halo, Nadila 👋',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Yuk, cek kondisi dan jadwal servis motor.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profile circle
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // ─── Scrollable Body ───────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Active Vehicle Card
                    ActiveVehicleCard(
                      vehicle: _activeVehicle,
                      onUpdateOdo: _showUpdateKmDialog,
                      onSwitchVehicle: _showSwitchVehicleModal,
                    ),
                    const SizedBox(height: 20),

                    // 2. Aksi Cepat
                    const Text(
                      'Aksi Cepat',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: QuickActionButton(
                            icon: Icons.two_wheeler,
                            label: 'Detail\nKendaraan',
                            backgroundColor: const Color(0xFFD8B4FE),
                            iconColor: const Color(0xFF6D28D9),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const VehicleListPage()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: QuickActionButton(
                            icon: Icons.construction_outlined,
                            label: 'Servis',
                            backgroundColor: const Color(0xFFBBF7D0),
                            iconColor: const Color(0xFF15803D),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AddServicePage()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3. Pengingat Servis
                    const Text(
                      'Pengingat Servis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._reminders.map(
                      (r) => ReminderSummaryCard(
                        reminder: r,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ReminderPage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Riwayat Servis Terbaru
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Riwayat Servis Terbaru',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ServiceHistoryPage()),
                            );
                          },
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF7C3AED),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ServiceHistoryCard(
                      serviceType: 'Servis Ringan',
                      date: '12 Agu 2026',
                      cost: 'Rp250.000',
                      icon: Icons.build_circle_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ServiceHistoryPage()),
                        );
                      },
                    ),
                    ServiceHistoryCard(
                      serviceType: 'Ganti Oli + Filter',
                      date: '15 Mei 2026',
                      cost: 'Rp180.000',
                      icon: Icons.opacity_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ServiceHistoryPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ─── Bottom Navigation ─────────────────────────────────────
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedBottomIndex,
          selectedItemColor: const Color(0xFF7C3AED),
          unselectedItemColor: Colors.grey.shade500,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          onTap: (idx) {
            setState(() => _selectedBottomIndex = idx);
            if (idx == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VehicleListPage()),
              );
            } else if (idx == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReminderPage()),
              );
            } else if (idx == 3) {
              // Akun - placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Halaman Akun segera hadir!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.two_wheeler_outlined),
              activeIcon: Icon(Icons.two_wheeler),
              label: 'Kendaraan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'Pengingat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}
