import 'package:flutter/material.dart';
import 'package:odotrack/modules/service/service_record.dart';
import 'package:odotrack/utils/formatters.dart';

class AddServicePage extends StatefulWidget {
  final int lastOdometer;

  const AddServicePage({
    super.key,
    this.lastOdometer = 12450,
  });

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  late DateTime _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _typeController = TextEditingController(text: 'Servis Ringan');
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _kmErrorText;
  String? _costErrorText;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController.text = Formatters.date(_selectedDate);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _typeController.dispose();
    _kmController.dispose();
    _costController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C4DFF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = Formatters.date(picked);
      });
    }
  }

  // Frame 07: Pilih Jenis Servis (Bottom Sheet)
  void _showServiceTypeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pilih Jenis Servis',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 1),
                const SizedBox(height: 8),
                _buildServiceTypeOption('Servis Ringan', Icons.build_outlined),
                _buildServiceTypeOption('Servis Besar', Icons.handyman_outlined),
                _buildServiceTypeOption('Ganti Oli', Icons.oil_barrel_outlined),
                _buildServiceTypeOption('Ganti Suku Cadang', Icons.settings_outlined),
                _buildServiceTypeOption('Lainnya', Icons.more_horiz),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceTypeOption(String title, IconData icon) {
    bool isSelected = _typeController.text == title;
    return InkWell(
      onTap: () {
        setState(() {
          _typeController.text = title;
        });
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF6C4DFF) : Colors.black54,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? const Color(0xFF6C4DFF) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF6C4DFF), size: 20),
          ],
        ),
      ),
    );
  }

  // Frame 09: Pop up Berhasil Simpan
  void _showSuccessDialog(ServiceRecord record) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Color(0xFF12B76A), size: 54),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Berhasil!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Data riwayat servis Anda telah\nberhasil disimpan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext); // Tutup dialog
                      Navigator.pop(context, record); // Kembali ke Riwayat Servis membawa data baru
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4DFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    if (type.contains('Oli')) return Icons.oil_barrel_outlined;
    if (type.contains('Rem') || type.contains('Suku Cadang')) return Icons.settings_outlined;
    if (type.contains('Besar')) return Icons.handyman_outlined;
    return Icons.build_outlined;
  }

  void _validateAndSave() {
    setState(() {
      _kmErrorText = null;
      _costErrorText = null;
    });

    // Validasi Kilometer
    String kmRaw = _kmController.text.trim().replaceAll('.', '').replaceAll(',', '');
    if (kmRaw.isEmpty) {
      setState(() => _kmErrorText = 'Kilometer wajib diisi.');
      return;
    }

    int? km = int.tryParse(kmRaw);
    if (km == null) {
      setState(() => _kmErrorText = 'Format kilometer tidak valid.');
      return;
    }

    // Frame 06: Validasi Error Kilometer tidak boleh lebih kecil dari entri sebelumnya
    if (km < widget.lastOdometer) {
      setState(() {
        _kmErrorText = 'Kilometer tidak boleh lebih kecil dari entri sebelumnya (${Formatters.number(widget.lastOdometer)} km).';
      });
      return;
    }

    // Validasi Biaya
    String costRaw = _costController.text.trim().replaceAll('.', '').replaceAll(',', '');
    if (costRaw.isEmpty) {
      setState(() => _costErrorText = 'Biaya servis wajib diisi.');
      return;
    }

    int? cost = int.tryParse(costRaw);
    if (cost == null) {
      setState(() => _costErrorText = 'Format biaya tidak valid.');
      return;
    }

    // Bentuk record baru
    final newRecord = ServiceRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jenisServis: _typeController.text,
      tanggal: _selectedDate,
      kilometer: km,
      biaya: cost,
      catatan: _noteController.text.trim().isEmpty ? 'Servis berkala rutin' : _noteController.text.trim(),
      icon: _getIconForType(_typeController.text),
    );

    _showSuccessDialog(newRecord);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Tambah Riwayat Servis',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field 1: Tanggal Servis
            _buildLabel('Tanggal Servis'),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: _inputDecoration(
                filled: true,
                suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20, color: Color(0xFF6C4DFF)),
              ),
            ),
            const SizedBox(height: 18),

            // Field 2: Jenis Servis
            _buildLabel('Jenis Servis'),
            const SizedBox(height: 8),
            TextField(
              controller: _typeController,
              readOnly: true,
              onTap: _showServiceTypeSheet,
              decoration: _inputDecoration(
                filled: true,
                suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6C4DFF)),
              ),
            ),
            const SizedBox(height: 18),

            // Field 3: Kilometer (Odometer) - Frame 05 & 06
            _buildLabel('Kilometer (Odometer)'),
            const SizedBox(height: 8),
            TextField(
              controller: _kmController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                hint: 'Contoh: 12500',
                filled: true,
                isError: _kmErrorText != null,
                borderColor: _kmErrorText != null ? Colors.red : Colors.transparent,
              ),
              onChanged: (_) {
                if (_kmErrorText != null) {
                  setState(() => _kmErrorText = null);
                }
              },
            ),
            if (_kmErrorText != null) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _kmErrorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 18),

            // Field 4: Biaya Servis
            _buildLabel('Biaya Servis (Rp)'),
            const SizedBox(height: 8),
            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                hint: 'Contoh: 250000',
                filled: true,
                isError: _costErrorText != null,
                borderColor: _costErrorText != null ? Colors.red : Colors.transparent,
              ),
              onChanged: (_) {
                if (_costErrorText != null) {
                  setState(() => _costErrorText = null);
                }
              },
            ),
            if (_costErrorText != null) ...[
              const SizedBox(height: 6),
              Text(
                _costErrorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 18),

            // Field 5: Catatan
            _buildLabel('Catatan'),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: _inputDecoration(hint: 'Tambahkan detail servis...', filled: true),
            ),
            const SizedBox(height: 18),

            // Field 6: Lampiran Foto Nota / Bukti Servis
            _buildLabel('Lampiran Foto Nota / Bukti Servis'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur kamera/galeri disiapkan untuk Progress 2 (Mockup UI)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9FB),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_alt_outlined, size: 26, color: Color(0xFF6C4DFF)),
                    SizedBox(height: 6),
                    Text(
                      'Ambil foto atau unggah dari galeri',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Simpan Riwayat
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _validateAndSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4DFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Simpan Riwayat',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
    );
  }

  InputDecoration _inputDecoration({
    String? hint,
    bool filled = false,
    Widget? suffixIcon,
    bool isError = false,
    Color borderColor = Colors.transparent,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: filled,
      fillColor: const Color(0xFFF9F9FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isError ? Colors.red : Colors.grey.shade200,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isError ? Colors.red : const Color(0xFF6C4DFF),
          width: 1.5,
        ),
      ),
    );
  }
}
