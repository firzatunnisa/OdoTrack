import 'package:flutter/material.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({Key? key}) : super(key: key);

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final TextEditingController _dateController = TextEditingController(text: '12 Agu 2026');
  final TextEditingController _typeController = TextEditingController(text: 'Servis Ringan');
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _kmErrorText;

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
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day} ${_getMonth(picked.month)} ${picked.year}";
      });
    }
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }

  void _showServiceTypeSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pilih Jenis Servis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              _buildServiceTypeOption('Servis Ringan'),
              _buildServiceTypeOption('Servis Besar'),
              _buildServiceTypeOption('Ganti Oli'),
              _buildServiceTypeOption('Ganti Suku Cadang'),
              _buildServiceTypeOption('Lainnya'),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceTypeOption(String title) {
    bool isSelected = _typeController.text == title;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF6C4DFF) : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF6C4DFF)) : null,
      onTap: () {
        setState(() {
          _typeController.text = title;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.green, size: 60),
                ),
                const SizedBox(height: 16),
                const Text('Berhasil!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 8),
                const Text(
                  'Data riwayat servis Anda telah\nberhasil disimpan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4DFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Selesai', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _validateAndSave() {
    setState(() {
      _kmErrorText = null;
      if (_kmController.text.isNotEmpty) {
        int? km = int.tryParse(_kmController.text);
        if (km != null && km < 10100) {
          _kmErrorText = 'Kilometer tidak boleh lebih kecil dari entri sebelumnya (10.100 km).';
        }
      }
    });

    if (_kmErrorText == null) {
      _showSuccessDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tambah Riwayat Servis',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Tanggal Servis'),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: _inputDecoration(filled: true),
            ),
            const SizedBox(height: 16),
            
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
            const SizedBox(height: 16),

            _buildLabel('Kilometer (Odometer)'),
            const SizedBox(height: 8),
            TextField(
              controller: _kmController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                filled: true,
                isError: _kmErrorText != null,
                borderColor: _kmErrorText != null ? Colors.red : Colors.transparent,
              ),
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
                      style: const TextStyle(color: Colors.red, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),

            _buildLabel('Biaya Servis (Rp)'),
            const SizedBox(height: 8),
            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(hint: 'Contoh: 250000', filled: true),
            ),
            const SizedBox(height: 16),

            _buildLabel('Catatan'),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: _inputDecoration(hint: 'Tambahkan detail servis...', filled: true),
            ),
            const SizedBox(height: 16),

            _buildLabel('Lampiran Foto Nota/Bukti Servis'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur kamera belum diaktifkan (Mockup UI)')),
                );
              },
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9FB),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_alt_outlined, size: 28, color: Color(0xFF6C4DFF)),
                    SizedBox(height: 8),
                    Text(
                      'Ambil foto atau unggah dari galeri',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _validateAndSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4DFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text('Simpan Riwayat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
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
        ),
      ),
    );
  }
}
