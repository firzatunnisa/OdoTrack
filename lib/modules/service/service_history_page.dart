import 'package:flutter/material.dart';
import 'package:odotrack/modules/service/service_record.dart';
import 'package:odotrack/modules/service/add_service_page.dart';
import 'package:odotrack/modules/service/service_detail_page.dart';

class ServiceHistoryPage extends StatefulWidget {
  const ServiceHistoryPage({super.key});

  @override
  State<ServiceHistoryPage> createState() => _ServiceHistoryPageState();
}

class _ServiceHistoryPageState extends State<ServiceHistoryPage> {
  // In-Memory State untuk riwayat servis
  final List<ServiceRecord> _records = [
    ServiceRecord(
      id: '1',
      jenisServis: 'Servis Ringan',
      tanggal: DateTime(2026, 8, 12),
      kilometer: 12450,
      biaya: 250000,
      catatan: 'Servis berkala semester, cek kelistrikan dan busi.',
      icon: Icons.build_outlined,
    ),
    ServiceRecord(
      id: '2',
      jenisServis: 'Ganti Oli + Filter',
      tanggal: DateTime(2026, 5, 15),
      kilometer: 10100,
      biaya: 180000,
      catatan: 'Ganti oli mesin synthetic dan filter oli baru.',
      icon: Icons.oil_barrel_outlined,
    ),
    ServiceRecord(
      id: '3',
      jenisServis: 'Ganti Kampas Rem',
      tanggal: DateTime(2026, 2, 10),
      kilometer: 6500,
      biaya: 120000,
      catatan: 'Ganti kampas rem depan original.',
      icon: Icons.settings_outlined,
    ),
  ];

  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Servis Ringan', 'Ganti Oli', 'Ganti Kampas Rem'];

  // Helper Formatter
  String _formatCurrency(int amount) {
    String str = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return 'Rp$str';
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Hitung data dinamis untuk Kartu Estimasi (Frame 01)
  int get _lastOdometer {
    if (_records.isEmpty) return 0;
    return _records.map((r) => r.kilometer).reduce((a, b) => a > b ? a : b);
  }

  int get _nextServiceKm => _lastOdometer + 2000;

  DateTime get _nextServiceDate {
    if (_records.isEmpty) return DateTime.now().add(const Duration(days: 90));
    final latestDate = _records.map((r) => r.tanggal).reduce((a, b) => a.isAfter(b) ? a : b);
    return DateTime(latestDate.year, latestDate.month + 3, latestDate.day);
  }

  int get _remainingDays {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(_nextServiceDate.year, _nextServiceDate.month, _nextServiceDate.day);
    return target.difference(today).inDays;
  }

  String get _statusLabel {
    if (_remainingDays > 14) return 'Aman';
    if (_remainingDays >= 0) return 'Mendekati';
    return 'Segera Servis';
  }

  Color get _statusBgColor {
    if (_remainingDays > 14) return const Color(0xFFDCFCE7);
    if (_remainingDays >= 0) return const Color(0xFFFEF3C7);
    return const Color(0xFFFEE2E2);
  }

  Color get _statusTextColor {
    if (_remainingDays > 14) return const Color(0xFF15803D);
    if (_remainingDays >= 0) return const Color(0xFFB45309);
    return const Color(0xFFB91C1C);
  }

  int get _totalCost => _records.fold(0, (sum, item) => sum + item.biaya);

  List<ServiceRecord> get _filteredRecords {
    if (_selectedFilter == 'Semua') return _records;
    return _records.where((r) {
      if (_selectedFilter == 'Ganti Oli') return r.jenisServis.contains('Oli');
      if (_selectedFilter == 'Ganti Kampas Rem') return r.jenisServis.contains('Rem');
      return r.jenisServis == _selectedFilter;
    }).toList();
  }

  // Navigasi ke Form Tambah Servis (Frame 05)
  Future<void> _openAddService() async {
    final newRecord = await Navigator.push<ServiceRecord>(
      context,
      MaterialPageRoute(
        builder: (context) => AddServicePage(lastOdometer: _lastOdometer),
      ),
    );

    if (newRecord != null) {
      setState(() {
        _records.insert(0, newRecord);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newRecord.jenisServis} berhasil dicatat!'),
          backgroundColor: const Color(0xFF12B76A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // Navigasi ke Detail Servis (Frame 04)
  Future<void> _openDetail(ServiceRecord record) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailPage(record: record),
      ),
    );

    if (result == 'deleted') {
      setState(() {
        _records.removeWhere((item) => item.id == record.id);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Catatan servis telah dihapus'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // Frame 03: Bottom Sheet Filter
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext sheetContext) {
        String tempFilter = _selectedFilter;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filter Riwayat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    const Text('Jenis Servis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    ..._filters.map((filter) {
                      bool isSelected = tempFilter == filter;
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(filter, style: const TextStyle(fontSize: 14)),
                        value: isSelected,
                        activeColor: const Color(0xFF6C4DFF),
                        onChanged: (bool? val) {
                          setSheetState(() {
                            tempFilter = filter;
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() => _selectedFilter = 'Semua');
                              Navigator.pop(sheetContext);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Reset', style: TextStyle(color: Colors.black87)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _selectedFilter = tempFilter);
                              Navigator.pop(sheetContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4DFF),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Terapkan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRecords;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Riwayat Servis',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        children: [
          // 1. Banner Estimasi Servis Berikutnya (Frame 01)
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.calendar_month, color: Color(0xFF6C4DFF), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estimasi Servis Berikutnya',
                            style: TextStyle(
                              color: Color(0xFF6C4DFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _records.isEmpty
                                ? 'Belum ada data servis untuk menghitung estimasi.'
                                : 'Berdasarkan riwayat, servis disarankan pada ${_formatDate(_nextServiceDate)} atau pada ${_formatNumber(_nextServiceKm)} km.',
                            style: const TextStyle(
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
                if (_records.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _statusLabel,
                          style: TextStyle(color: _statusTextColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sisa ${_formatNumber(_nextServiceKm - _lastOdometer)} km / $_remainingDays hari',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Kartu Ringkasan (Total Biaya & Jumlah Servis) - Frame 01
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Biaya Servis',
                        style: TextStyle(color: Colors.black54, fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatCurrency(_totalCost),
                        style: const TextStyle(
                          color: Color(0xFF6C4DFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jumlah Servis',
                        style: TextStyle(color: Colors.black54, fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_records.length} kali',
                        style: const TextStyle(
                          color: Color(0xFF6C4DFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Header List & Tombol Filter (Frame 01)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Semua Riwayat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              InkWell(
                onTap: _showFilterSheet,
                child: Row(
                  children: const [
                    Icon(Icons.tune, size: 16, color: Color(0xFF6C4DFF)),
                    SizedBox(width: 4),
                    Text(
                      'Filter',
                      style: TextStyle(color: Color(0xFF6C4DFF), fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4. Horizontal Filter Chips (Frame 01)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                bool isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = filter);
                      }
                    },
                    selectedColor: const Color(0xFF6C4DFF),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF6C4DFF) : Colors.grey.shade300,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // 5. Daftar Riwayat Servis ATAU State Kosong (Frame 02)
          if (filtered.isEmpty)
            _buildEmptyState()
          else
            ...filtered.map((record) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildServiceCard(record),
            )),

          const SizedBox(height: 80), // Ruang untuk FloatingActionButton
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddService,
        backgroundColor: const Color(0xFF6C4DFF),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // Frame 02: Riwayat Kosong
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F0FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.build_outlined, color: Color(0xFF6C4DFF), size: 36),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada riwayat servis',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Catat riwayat servis pertama kamu agar kondisi motor selalu terpantau.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 42,
            child: ElevatedButton(
              onPressed: _openAddService,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4DFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text(
                'Catat Servis Pertama',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card Item Riwayat Servis (Frame 01)
  Widget _buildServiceCard(ServiceRecord record) {
    return InkWell(
      onTap: () => _openDetail(record),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
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
              child: Icon(record.icon, color: const Color(0xFF6C4DFF), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.jenisServis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(record.tanggal),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCurrency(record.biaya),
                  style: const TextStyle(
                    color: Color(0xFF12B76A),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatNumber(record.kilometer)} km',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
