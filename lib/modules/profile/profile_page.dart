import 'package:flutter/material.dart';
import 'about_page.dart';
import '../auth/landing_page.dart';
import '../vehicle/vehicle_list_page.dart';
import '../dashboard/nearby_locations_page.dart';
import '../dashboard/reminder_page.dart';
import '../main_screen.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  final bool isEmbedded;
  const ProfilePage({super.key, this.isEmbedded = false});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Nadila Lailany';
  String _userRole = 'Pemilik Kendaraan Pribadi';

  // Notification settings state
  bool _notifService = true;
  bool _notifTax = true;
  bool _notifH7 = true;
  bool _soundEnabled = true;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar dari Akun', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LandingPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final roleController = TextEditingController(text: _userRole);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Perbarui nama dan status kepemilikan Anda:',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: roleController,
              decoration: InputDecoration(
                labelText: 'Status / Peran',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  _userName = nameController.text.trim();
                  _userRole = roleController.text.trim().isNotEmpty
                      ? roleController.text.trim()
                      : 'Pemilik Kendaraan Pribadi';
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil berhasil diperbarui!'),
                    backgroundColor: Color(0xFF16A34A),
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

  void _showNotificationSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pengaturan Notifikasi Pengingat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Atur kapan dan bagaimana Anda ingin diingatkan tentang servis dan pajak.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeTrackColor: const Color(0xFF4F46E5),
                title: const Text(
                  'Pengingat Servis Odometer',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Beri tahu saat mendekati target kilometer',
                  style: TextStyle(fontSize: 12.5),
                ),
                value: _notifService,
                onChanged: (val) {
                  setSheetState(() => _notifService = val);
                  setState(() => _notifService = val);
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeTrackColor: const Color(0xFF4F46E5),
                title: const Text(
                  'Pengingat Pajak STNK',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Beri tahu saat mendekati jatuh tempo tahunan',
                  style: TextStyle(fontSize: 12.5),
                ),
                value: _notifTax,
                onChanged: (val) {
                  setSheetState(() => _notifTax = val);
                  setState(() => _notifTax = val);
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeTrackColor: const Color(0xFF4F46E5),
                title: const Text(
                  'Peringatan Dini (H-7)',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Notifikasi seminggu sebelum jatuh tempo',
                  style: TextStyle(fontSize: 12.5),
                ),
                value: _notifH7,
                onChanged: (val) {
                  setSheetState(() => _notifH7 = val);
                  setState(() => _notifH7 = val);
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeTrackColor: const Color(0xFF4F46E5),
                title: const Text(
                  'Suara & Getar',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Nyalakan efek suara untuk pengingat penting',
                  style: TextStyle(fontSize: 12.5),
                ),
                value: _soundEnabled,
                onChanged: (val) {
                  setSheetState(() => _soundEnabled = val);
                  setState(() => _soundEnabled = val);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pengaturan notifikasi berhasil disimpan!'),
                        backgroundColor: Color(0xFF16A34A),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text(
                    'Simpan Pengaturan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ─── Header & Profile Card Stack ─────────────────────────
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Blue Header Background
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  bottom: 60,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Profil Akun',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Profile Card (floating slightly below header)
              Positioned(
                bottom: -36,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar circle
                      Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEEF2FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: Color(0xFF4F46E5),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // User info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userName,
                              style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _userRole,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Edit button
                      InkWell(
                        onTap: _showEditProfileDialog,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),

          // ─── Menu Items ──────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section: Pengaturan
                  const Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.two_wheeler_rounded,
                    iconBgColor: const Color(0xFFEDE9FE),
                    iconColor: const Color(0xFF7C3AED),
                    title: 'Data Kendaraan Saya',
                    onTap: () {
                      if (widget.isEmbedded) {
                        MainScreen.switchTab(context, 1);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VehicleListPage(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    iconBgColor: const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0284C7),
                    title: 'Cari Bengkel & Samsat Terdekat',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NearbyLocationsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.notifications_none_rounded,
                    iconBgColor: const Color(0xFFFEF3C7),
                    iconColor: const Color(0xFFD97706),
                    title: 'Pengaturan Notifikasi Pengingat',
                    onTap: _showNotificationSettingsSheet,
                  ),
                  const SizedBox(height: 24),

                  // Section: Tentang Aplikasi
                  const Text(
                    'Tentang Aplikasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.info_outline_rounded,
                    iconBgColor: const Color(0xFFF1F5F9),
                    iconColor: const Color(0xFF64748B),
                    title: 'Tentang OdoTrack',
                    trailingText: 'v1.0',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.logout_rounded,
                    iconBgColor: const Color(0xFFFEE2E2),
                    iconColor: const Color(0xFFEF4444),
                    title: 'Keluar dari Akun',
                    onTap: _showLogoutDialog,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),

      // ─── Bottom Navigation Bar ─────────────────────────────────
      bottomNavigationBar: widget.isEmbedded
          ? null
          : AppBottomNavBar(
              currentIndex: 3,
              onTap: (idx) {
                if (idx == 0) {
                  Navigator.pop(context);
                } else if (idx == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const VehicleListPage()),
                  );
                } else if (idx == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ReminderPage()),
                  );
                }
              },
            ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              if (trailingText != null) ...[
                Text(
                  trailingText,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
