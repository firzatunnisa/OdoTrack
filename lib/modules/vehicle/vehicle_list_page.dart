import 'package:flutter/material.dart';
import 'package:odotrack/modules/vehicle/add_vehicle_page.dart';
import 'package:odotrack/modules/vehicle/vehicle_detail_page.dart';
import 'package:odotrack/modules/dashboard/reminder_page.dart';
import 'package:odotrack/modules/profile/profile_page.dart';
import 'package:odotrack/theme/app_colors.dart';
import 'package:odotrack/widgets/app_bottom_nav_bar.dart';

class VehicleListPage extends StatefulWidget {
  final bool isEmbedded;
  const VehicleListPage({super.key, this.isEmbedded = false});

  @override
  State<VehicleListPage> createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  // In-memory data
  List<Map<String, dynamic>> vehicles = [
    {
      'id': '1',
      'name': 'Honda Scoopy',
      'type': 'Scoopy',
      'year': '2021',
      'plate': 'BA 4321 KZ',
      'odometer': '12450',
      'isActive': true,
      'statusMessage': 'Aktif',
      'lastService': '12 Agu 2026',
    },
    {
      'id': '2',
      'name': 'Yamaha NMAX',
      'type': 'NMAX',
      'year': '2020',
      'plate': 'B 4321 DAK',
      'odometer': '24500',
      'isActive': false,
      'statusMessage': 'Belum diservis > 30 hari',
      'lastService': '1 Jan 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Collect all existing plates for duplicate validation
    final allPlates = vehicles.map((v) => v['plate']?.toString() ?? '').toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: !widget.isEmbedded,
        title: const Text(
          'Daftar Kendaraan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          vehicles.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C4DFF).withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.two_wheeler,
                            size: 52,
                            color: Color(0xFF6C4DFF),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Belum Ada Kendaraan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tambahkan kendaraan pertama kamu\nuntuk mulai memantau servis & odometer.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return _buildVehicleCard(vehicle, index, allPlates);
                  },
                ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                final newVehicle = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddVehiclePage(
                      existingPlates: allPlates,
                    ),
                  ),
                );
                
                if (newVehicle != null) {
                  setState(() {
                    vehicles.add(newVehicle);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4DFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Tambah Kendaraan Baru',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.isEmbedded
          ? null
          : AppBottomNavBar(
              currentIndex: 1,
              onTap: (index) {
                if (index == 0) {
                  Navigator.pop(context);
                } else if (index == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReminderPage(),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                }
              },
            ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle, int index, List<String> allPlates) {
    bool isActive = vehicle['isActive'] ?? true;
    Color cardColor = isActive ? Colors.white : const Color(0xFFFFF5F5);
    Color borderColor = isActive ? Colors.grey.shade300 : Colors.red.shade100;
    
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleDetailPage(
              vehicle: vehicle,
              existingPlates: allPlates,
            ),
          ),
        );

        if (result != null) {
          setState(() {
            if (result['action'] == 'delete') {
              vehicles.removeAt(index);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kendaraan berhasil dihapus!'), backgroundColor: Colors.green),
              );
            } else if (result['action'] == 'update') {
              vehicles[index] = result['data'];
            }
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.two_wheeler,
                color: Color(0xFF6C4DFF),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vehicle['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isActive ? 'Aktif' : 'Tidak Aktif',
                          style: TextStyle(
                            color: isActive ? Colors.green : Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vehicle['plate'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  if (!isActive && vehicle['statusMessage'] != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          vehicle['statusMessage'],
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
