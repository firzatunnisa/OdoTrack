import 'package:flutter/material.dart';
import 'models/reminder_model.dart';
import 'widgets/reminder_item_card.dart';
import 'widgets/add_reminder_sheet.dart';
import 'nearby_locations_page.dart';
import '../vehicle/vehicle_list_page.dart';
import '../profile/profile_page.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class ReminderPage extends StatefulWidget {
  final bool isEmbedded;
  const ReminderPage({super.key, this.isEmbedded = false});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample initial reminders
  final List<ReminderModel> _reminders = [
    ReminderModel(
      id: '1',
      title: 'Ganti Oli Mesin',
      category: 'service',
      vehicleName: 'Honda Vario 160 (B 4567 XYZ)',
      targetKm: 14500,
      currentKm: 14250,
      status: 'warning',
      description: 'Gunakan oli AHM Oil SPX 2 10W-30 (0.8L) untuk performa matic optimal.',
      isEnabled: true,
    ),
    ReminderModel(
      id: '2',
      title: 'Pajak STNK Tahunan',
      category: 'tax',
      vehicleName: 'Honda Vario 160 (B 4567 XYZ)',
      dueDate: DateTime.now().add(const Duration(days: 12)),
      status: 'critical',
      description: 'Jatuh tempo pembayaran PKB & SWDKLLJ di Samsat terdekat atau aplikasi Signal.',
      isEnabled: true,
    ),
    ReminderModel(
      id: '3',
      title: 'Ganti Oli Gardan / Transmisi',
      category: 'service',
      vehicleName: 'Honda Vario 160 (B 4567 XYZ)',
      targetKm: 16000,
      currentKm: 14250,
      status: 'safe',
      description: 'Ganti oli transmisi setiap 2x ganti oli mesin (120ml).',
      isEnabled: true,
    ),
    ReminderModel(
      id: '4',
      title: 'Pemeriksaan Busi & Filter Udara',
      category: 'service',
      vehicleName: 'Honda Vario 160 (B 4567 XYZ)',
      targetKm: 16000,
      currentKm: 14250,
      status: 'safe',
      description: 'Bersihkan saringan udara dan cek kerenggangan elektroda busi.',
      isEnabled: true,
    ),
    ReminderModel(
      id: '5',
      title: 'Pajak STNK 5 Tahunan & Ganti Plat',
      category: 'tax',
      vehicleName: 'Honda Vario 160 (B 4567 XYZ)',
      dueDate: DateTime.now().add(const Duration(days: 410)),
      status: 'safe',
      description: 'Cek fisik kendaraan di Samsat Induk untuk perpanjangan masa berlaku STNK 5 tahun.',
      isEnabled: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addNewReminder(ReminderModel reminder) {
    setState(() {
      _reminders.insert(0, reminder);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pengingat "${reminder.title}" berhasil ditambahkan!'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleReminder(int index, bool val) {
    setState(() {
      _reminders[index] = _reminders[index].copyWith(isEnabled: val);
    });
  }

  void _markDone(ReminderModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Selesai'),
        content: Text('Tandai "${item.title}" sudah dikerjakan/dibayar? Jadwal akan diperbarui ke periode berikutnya.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                final idx = _reminders.indexWhere((r) => r.id == item.id);
                if (idx != -1) {
                  if (item.category == 'tax') {
                    _reminders[idx] = item.copyWith(
                      dueDate: (item.dueDate ?? DateTime.now()).add(const Duration(days: 365)),
                      status: 'safe',
                    );
                  } else {
                    _reminders[idx] = item.copyWith(
                      targetKm: (item.targetKm ?? 14250) + 4000,
                      status: 'safe',
                    );
                  }
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.title} selesai! Jadwal diperbarui ke periode berikutnya.'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Ya, Selesai'),
          ),
        ],
      ),
    );
  }

  void _deleteReminder(ReminderModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Pengingat', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus pengingat "${item.title}"?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _reminders.removeWhere((r) => r.id == item.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pengingat "${item.title}" berhasil dihapus'),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(ReminderModel item) {
    final titleCtrl = TextEditingController(text: item.title);
    final descCtrl = TextEditingController(text: item.description);
    final kmCtrl = TextEditingController(text: item.targetKm != null ? item.targetKm.toString() : '');
    DateTime? selectedDate = item.dueDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ubah Pengingat',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: 'Judul Pengingat',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (item.category == 'tax') ...[
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 30)),
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                          );
                          if (picked != null) {
                            setModalState(() => selectedDate = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedDate == null
                                    ? 'Pilih Tanggal Jatuh Tempo'
                                    : 'Jatuh Tempo: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const Icon(Icons.calendar_month, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      TextField(
                        controller: kmCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Target Kilometer (KM)',
                          suffixText: 'KM',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextField(
                      controller: descCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Catatan / Deskripsi',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (titleCtrl.text.trim().isEmpty) return;
                          final newKm = int.tryParse(kmCtrl.text);
                          Navigator.pop(ctx);
                          setState(() {
                            final idx = _reminders.indexWhere((r) => r.id == item.id);
                            if (idx != -1) {
                              _reminders[idx] = item.copyWith(
                                title: titleCtrl.text.trim(),
                                description: descCtrl.text.trim(),
                                targetKm: item.category != 'tax' ? newKm ?? item.targetKm : null,
                                dueDate: item.category == 'tax' ? selectedDate ?? item.dueDate : null,
                              );
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pengingat "${titleCtrl.text}" berhasil diperbarui!'),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
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

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddReminderSheet(onAdd: _addNewReminder),
    );
  }

  List<ReminderModel> _getFilteredReminders(int tabIndex) {
    if (tabIndex == 1) {
      return _reminders.where((r) => r.category == 'service').toList();
    } else if (tabIndex == 2) {
      return _reminders.where((r) => r.category == 'tax').toList();
    }
    return _reminders;
  }

  @override
  Widget build(BuildContext context) {
    final criticalCount = _reminders.where((r) => r.status == 'critical' && r.isEnabled).length;
    final warningCount = _reminders.where((r) => r.status == 'warning' && r.isEnabled).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Jadwal & Pengingat',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: !widget.isEmbedded,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.near_me_outlined),
            tooltip: 'Cari Bengkel & Samsat',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NearbyLocationsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah Pengingat',
            onPressed: _showAddSheet,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Servis Berkala'),
            Tab(text: 'Pajak & STNK'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Banner Status
          if (criticalCount > 0 || warningCount > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: criticalCount > 0 ? const Color(0xFFFEF2F2) : const Color(0xFFFFFBEB),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: criticalCount > 0 ? const Color(0xFFEF4444) : const Color(0xFFF59E0B),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      criticalCount > 0
                          ? 'Perhatian: Ada $criticalCount pengingat mendesak yang butuh tindakan!'
                          : 'Ada $warningCount pengingat servis yang mendekati jadwal.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: criticalCount > 0 ? const Color(0xFFB91C1C) : const Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReminderList(_getFilteredReminders(0)),
                _buildReminderList(_getFilteredReminders(1)),
                _buildReminderList(_getFilteredReminders(2)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.notification_add_outlined),
        label: const Text('Buat Pengingat'),
      ),
      bottomNavigationBar: widget.isEmbedded
          ? null
          : AppBottomNavBar(
              currentIndex: 2,
              onTap: (index) {
                if (index == 0) {
                  Navigator.pop(context);
                } else if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VehicleListPage(),
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

  Widget _buildReminderList(List<ReminderModel> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'Belum ada pengingat di kategori ini',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final originalIdx = _reminders.indexWhere((r) => r.id == item.id);
        return ReminderItemCard(
          reminder: item,
          onToggle: (val) => _toggleReminder(originalIdx, val),
          onMarkDone: () => _markDone(item),
          onEdit: () => _showEditSheet(item),
          onDelete: () => _deleteReminder(item),
        );
      },
    );
  }
}
