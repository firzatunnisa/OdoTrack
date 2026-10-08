import 'package:flutter/material.dart';
import 'package:odotrack/modules/vehicle/add_vehicle_page.dart';
import 'package:odotrack/modules/vehicle/vehicle_detail_page.dart';

class VehicleListPage extends StatefulWidget {
  const VehicleListPage({super.key});

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Daftar Kendaraan',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          vehicles.isEmpty
              ? const Center(child: Text('Belum ada kendaraan. Silakan tambah baru.'))
              : ListView.builder(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return _buildVehicleCard(vehicle, index);
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
                  MaterialPageRoute(builder: (context) => const AddVehiclePage()),
                );
                
                if (newVehicle != null) {
                  setState(() {
                    vehicles.add(newVehicle);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B61FF),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // 'Kendaraan' is selected
        selectedItemColor: const Color(0xFF5B61FF),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            activeIcon: Icon(Icons.directions_car),
            label: 'Kendaraan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            activeIcon: Icon(Icons.build),
            label: 'Servis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle, int index) {
    bool isActive = vehicle['isActive'] ?? true;
    Color cardColor = isActive ? Colors.white : const Color(0xFFFFF5F5);
    Color borderColor = isActive ? Colors.grey.shade300 : Colors.red.shade100;
    
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleDetailPage(vehicle: vehicle),
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
                color: Color(0xFF5B61FF),
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
