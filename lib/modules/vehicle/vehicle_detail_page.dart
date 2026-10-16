import 'package:flutter/material.dart';
import 'package:odotrack/modules/vehicle/add_vehicle_page.dart';

class VehicleDetailPage extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  final List<String> existingPlates;

  const VehicleDetailPage({
    super.key,
    required this.vehicle,
    this.existingPlates = const [],
  });

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  late Map<String, dynamic> currentVehicle;

  @override
  void initState() {
    super.initState();
    currentVehicle = Map.from(widget.vehicle);
  }

  void _showUpdateOdometerDialog() {
    final TextEditingController odometerController =
        TextEditingController(text: currentVehicle['odometer']);
    final formKey = GlobalKey<FormState>();
    final currentOdoValue = int.tryParse(currentVehicle['odometer'] ?? '0') ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Update Odometer',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Odometer Terakhir (km)', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: odometerController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF6C4DFF)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Odometer wajib diisi';
                    }
                    final odo = int.tryParse(value.trim());
                    if (odo == null) {
                      return 'Odometer harus berupa angka';
                    }
                    if (odo < 0) {
                      return 'Odometer tidak boleh negatif';
                    }
                    if (odo < currentOdoValue) {
                      return 'Tidak boleh kurang dari odometer saat ini ($currentOdoValue km)';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    currentVehicle['odometer'] = odometerController.text.trim();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Odometer berhasil diupdate!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4DFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_rounded, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Hapus Kendaraan?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Apakah Anda yakin ingin menghapus ${currentVehicle['name']}? Semua riwayat servis juga akan ikut terhapus permanen.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context, {'action': 'delete'}); // pop page with delete action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Ya, Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = currentVehicle['isActive'] ?? true;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, {'action': 'update', 'data': currentVehicle});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: const Color(0xFF6C4DFF),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            onPressed: () {
              Navigator.pop(context, {'action': 'update', 'data': currentVehicle});
            },
          ),
          title: const Text(
            'Detail Kendaraan',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Detail Kendaraan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentVehicle['isActive'] = !isActive;
                              currentVehicle['statusMessage'] = !isActive ? 'Aktif' : 'Tidak aktif';
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isActive ? Colors.green.shade200 : Colors.red.shade200,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isActive ? Icons.check_circle : Icons.cancel,
                                  size: 13,
                                  color: isActive ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isActive ? 'Aktif' : 'Tidak Aktif',
                                  style: TextStyle(
                                    color: isActive ? Colors.green : Colors.red,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.swap_horiz, size: 13, color: isActive ? Colors.green : Colors.red),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow('Nama Kendaraan', '${currentVehicle['name']} ${currentVehicle['year'] ?? ''}'),
                    const SizedBox(height: 12),
                    _buildDetailRow('Nomor Polisi', currentVehicle['plate'] ?? '-'),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Odometer', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        Row(
                          children: [
                            Text('${currentVehicle['odometer'] ?? '0'} km', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: _showUpdateOdometerDialog,
                              child: const Icon(Icons.edit, size: 16, color: Color(0xFF6C4DFF)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Terakhir Servis', currentVehicle['lastService'] ?? '-'),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              // Build list of plates excluding current vehicle's plate
                              final otherPlates = widget.existingPlates
                                  .where((p) => p.toUpperCase().replaceAll(' ', '') !=
                                      (currentVehicle['plate'] ?? '').toString().toUpperCase().replaceAll(' ', ''))
                                  .toList();

                              final updatedVehicle = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddVehiclePage(
                                    vehicle: currentVehicle,
                                    existingPlates: otherPlates,
                                  ),
                                ),
                              );

                              if (updatedVehicle != null) {
                                setState(() {
                                  currentVehicle = updatedVehicle;
                                });
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF6C4DFF)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Ubah Data', style: TextStyle(color: Color(0xFF6C4DFF), fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showDeleteConfirmation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade50,
                              foregroundColor: Colors.red,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }
}
