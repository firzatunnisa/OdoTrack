import 'package:flutter/material.dart';
import 'models/reminder_model.dart';
import 'widgets/active_vehicle_card.dart';
import 'widgets/quick_action_button.dart';
import 'widgets/reminder_summary_card.dart';
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
    name: 'Honda Vario 160',
    plateNumber: 'B 4567 XYZ',
    currentKm: 14250,
    type: 'Matic',
    lastServiceDate: '12 Sep 2026 (12.000 KM)',
  );

  // Reminders preview list
  final List<ReminderModel> _urgentReminders = [
    const ReminderModel(
      id: '1',
      title: 'Ganti Oli Mesin (AHM SPX 2)',
      category: 'service',
      vehicleName: 'Honda Vario 160 (B 4567 XYZ)',
      targetKm: 14500,
      currentKm: 14250,
      status: 'warning',
      description: 'Tersisa 250 KM lagi menuju batas penggantian oli berkala.',
      isEnabled: true,
    ),
    ReminderModel(
      id: '2',
      title: 'Pajak STNK Tahunan',
      category: 'tax',
      vehicleName: 'Honda Vario 160 (B 4567 XYZ)',
      dueDate: DateTime.now().add(const Duration(days: 12)),
      status: 'critical',
      description: 'Jatuh tempo 12 hari lagi. Segera bayar di Samsat atau Signal.',
      isEnabled: true,
    ),
    const ReminderModel(
      id: '3',
      title: 'Ganti Oli Gardan',
      category: 'service',
      vehicleName: 'Honda Vario 160 (B 4567 XYZ)',
      targetKm: 16000,
      currentKm: 14250,
      status: 'safe',
      description: 'Tersisa 1.750 KM lagi.',
      isEnabled: true,
    ),
  ];

  void _showUpdateKmDialog() {
    final controller = TextEditingController(text: _activeVehicle.currentKm.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Kilometer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan angka odometer terbaru di speedometer motor Anda:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Kilometer Sekarang',
                suffixText: 'KM',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final newKm = int.tryParse(controller.text.replaceAll(RegExp(r'[^0-9]'), ''));
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
                    content: Text('Kilometer berhasil diupdate menjadi $newKm KM!'),
                    backgroundColor: const Color(0xFF10B981),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kilometer baru tidak boleh lebih kecil dari sebelumnya.'),
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
                backgroundColor: Color(0xFF1E3A8A),
                child: Icon(Icons.two_wheeler, color: Colors.white),
              ),
              title: const Text('Honda Vario 160', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('B 4567 XYZ • 14.250 KM'),
              trailing: const Icon(Icons.check_circle, color: Color(0xFF10B981)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.two_wheeler, color: Colors.grey),
              ),
              title: const Text('Yamaha NMAX 155', style: TextStyle(fontWeight: FontWeight.bold)),
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
              leading: const Icon(Icons.add_circle_outline, color: Color(0xFF2563EB)),
              title: const Text('Tambah Kendaraan Lain', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AddVehiclePage()));
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
              child: const Icon(Icons.person, color: Color(0xFF1E3A8A)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo, Nadila 👋',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Rawat motormu tepat waktu',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF0F172A), size: 26),
                tooltip: 'Pengingat',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReminderPage()),
                  );
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Active Vehicle Hero Card
            ActiveVehicleCard(
              vehicle: _activeVehicle,
              onUpdateOdo: _showUpdateKmDialog,
              onSwitchVehicle: _showSwitchVehicleModal,
            ),
            const SizedBox(height: 24),

            // 2. Quick Actions Navigation Section
            const Text(
              'Aksi Cepat & Navigasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: QuickActionButton(
                    icon: Icons.two_wheeler,
                    label: 'Motor Saya\n(Loudysa)',
                    color: const Color(0xFF3B82F6),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VehicleListPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickActionButton(
                    icon: Icons.build_circle_outlined,
                    label: 'Riwayat Servis\n(Firza)',
                    color: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ServiceHistoryPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickActionButton(
                    icon: Icons.notifications_active_outlined,
                    label: 'Semua\nPengingat',
                    color: const Color(0xFFF59E0B),
                    badge: '2',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ReminderPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickActionButton(
                    icon: Icons.post_add,
                    label: 'Catat\nServis',
                    color: const Color(0xFF8B5CF6),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddServicePage()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Urgent Reminders Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pengingat Terdekat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReminderPage()),
                    );
                  },
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ..._urgentReminders.map(
              (r) => ReminderSummaryCard(
                reminder: r,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReminderPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // 4. Quick Tips / Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: Color(0xFF2563EB), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tips Perawatan OdoTrack',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jangan lupa update angka odometer Anda setiap habis perjalanan jauh agar jadwal pengingat tetap akurat!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade900,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        selectedItemColor: const Color(0xFF1E3A8A),
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) {
          setState(() {
            _selectedBottomIndex = idx;
          });
          if (idx == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const VehicleListPage()));
          } else if (idx == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceHistoryPage()));
          } else if (idx == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ReminderPage()));
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
            icon: Icon(Icons.build_outlined),
            activeIcon: Icon(Icons.build),
            label: 'Servis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Pengingat',
          ),
        ],
      ),
    );
  }
}
