import 'package:flutter/material.dart';

class LocationModel {
  final String id;
  final String name;
  final String category; // 'bengkel' | 'samsat'
  final String address;
  final double distanceKm;
  final String openHours;
  final String phone;
  final double rating;

  const LocationModel({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.distanceKm,
    required this.openHours,
    required this.phone,
    required this.rating,
  });
}

class NearbyLocationsPage extends StatefulWidget {
  const NearbyLocationsPage({super.key});

  @override
  State<NearbyLocationsPage> createState() => _NearbyLocationsPageState();
}

class _NearbyLocationsPageState extends State<NearbyLocationsPage> {
  String _selectedFilter = 'all'; // 'all', 'bengkel', 'samsat'
  String _searchQuery = '';

  final List<LocationModel> _locations = const [
    LocationModel(
      id: 'l1',
      name: 'AHASS Astra Motor - Padang',
      category: 'bengkel',
      address: 'Jl. Khatib Sulaiman No. 12, Padang',
      distanceKm: 1.2,
      openHours: 'Buka • Tutup 17.00',
      phone: '(0751) 7051234',
      rating: 4.8,
    ),
    LocationModel(
      id: 'l2',
      name: 'Kantor Samsat Padang (Induk)',
      category: 'samsat',
      address: 'Jl. Asahan No. 2, Rimbo Kaluang, Padang',
      distanceKm: 2.5,
      openHours: 'Buka • Tutup 15.00',
      phone: '(0751) 7059988',
      rating: 4.5,
    ),
    LocationModel(
      id: 'l3',
      name: 'Yamaha Tjahaja Baru Motor',
      category: 'bengkel',
      address: 'Jl. Damar No. 45, Padang Barat',
      distanceKm: 3.1,
      openHours: 'Buka • Tutup 17.00',
      phone: '(0751) 32188',
      rating: 4.7,
    ),
    LocationModel(
      id: 'l4',
      name: 'Samsat Keliling (Plaza Andalas)',
      category: 'samsat',
      address: 'Pelataran Parkir Plaza Andalas, Padang',
      distanceKm: 3.8,
      openHours: 'Buka • Tutup 14.00 (Khusus PKB Tahunan)',
      phone: '0812-3456-7890',
      rating: 4.6,
    ),
    LocationModel(
      id: 'l5',
      name: 'Bengkel Motor Berkah Jaya (Umum)',
      category: 'bengkel',
      address: 'Jl. Prof. Dr. Hamka No. 88, Padang',
      distanceKm: 4.0,
      openHours: 'Buka • Tutup 20.00',
      phone: '0852-1122-3344',
      rating: 4.6,
    ),
  ];

  List<LocationModel> get _filteredLocations {
    return _locations.where((loc) {
      final matchesFilter = _selectedFilter == 'all' || loc.category == _selectedFilter;
      final matchesSearch = loc.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          loc.address.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Lokasi Bengkel & Samsat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Search & Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search Field
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Cari bengkel resmi atau kantor Samsat...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF1E3A8A)),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Semua Lokasi', 'all', Icons.place_outlined),
                      const SizedBox(width: 8),
                      _buildFilterChip('Bengkel Servis', 'bengkel', Icons.build_outlined),
                      const SizedBox(width: 8),
                      _buildFilterChip('Kantor Samsat', 'samsat', Icons.account_balance_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Map Preview Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: 130,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.15,
                    child: Center(
                      child: Icon(Icons.map_outlined, size: 140, color: Colors.blue.shade200),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2563EB),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.my_location, color: Colors.white, size: 14),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'GPS / Radar Terdekat Aktif',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Menampilkan ${_filteredLocations.length} titik bengkel & Samsat di sekitar lokasi Anda saat ini.',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List of Locations
          Expanded(
            child: _filteredLocations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_off_outlined, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Lokasi tidak ditemukan',
                          style: TextStyle(fontSize: 15, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: _filteredLocations.length,
                    itemBuilder: (context, index) {
                      final item = _filteredLocations[index];
                      return _buildLocationCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = _selectedFilter == value;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E3A8A) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey.shade700),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(LocationModel item) {
    final isSamsat = item.category == 'samsat';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSamsat ? const Color(0xFFEF4444).withValues(alpha: 0.12) : const Color(0xFF2563EB).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSamsat ? Icons.account_balance : Icons.build,
                  color: isSamsat ? const Color(0xFFEF4444) : const Color(0xFF2563EB),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.address,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Detail Info Badges
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.near_me, size: 12, color: Color(0xFF10B981)),
                    const SizedBox(width: 4),
                    Text(
                      '${item.distanceKm} KM',
                      style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${item.rating}',
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.openHours,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Menghubungi ${item.phone}...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E3A8A),
                    side: const BorderSide(color: Color(0xFF1E3A8A)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.phone, size: 16),
                  label: const Text('Telepon', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Membuka rute navigasi menuju ${item.name}...'),
                        backgroundColor: const Color(0xFF2563EB),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.directions, size: 16),
                  label: const Text('Rute Maps', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
