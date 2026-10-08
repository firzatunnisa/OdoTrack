import 'package:flutter/material.dart';

class AddVehiclePage extends StatefulWidget {
  final Map<String, dynamic>? vehicle;

  const AddVehiclePage({super.key, this.vehicle});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _merkController = TextEditingController();
  final _tipeController = TextEditingController();
  final _tahunController = TextEditingController();
  final _nomorPolisiController = TextEditingController();
  final _odometerController = TextEditingController();

  bool get isEdit => widget.vehicle != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      // We parse the brand out of 'name' for simplicity, assuming "Brand Type" format.
      // But let's just populate based on what we have.
      _merkController.text = widget.vehicle!['name'].toString().split(' ').first;
      _tipeController.text = widget.vehicle!['type'] ?? '';
      _tahunController.text = widget.vehicle!['year'] ?? '';
      _nomorPolisiController.text = widget.vehicle!['plate'] ?? '';
      _odometerController.text = widget.vehicle!['odometer'] ?? '';
    }
  }

  @override
  void dispose() {
    _merkController.dispose();
    _tipeController.dispose();
    _tahunController.dispose();
    _nomorPolisiController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          isEdit ? 'Ubah Kendaraan' : 'Tambah Kendaraan',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detail Motor Anda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Photo upload placeholder
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.indigo.shade100,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF5B61FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ambil atau Unggah Foto\n(Opsional)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Form Fields
                _buildTextField(
                  label: 'Merk (Brand)',
                  hint: 'Contoh: Honda',
                  controller: _merkController,
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  label: 'Tipe',
                  hint: 'Contoh: Scoopy',
                  controller: _tipeController,
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  label: 'Tahun',
                  hint: 'Contoh: 2021',
                  controller: _tahunController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  label: 'Nomor Polisi',
                  hint: 'Contoh: B 4321 KZ',
                  controller: _nomorPolisiController,
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  label: 'Odometer Terakhir (km)',
                  hint: 'Contoh: 12490',
                  controller: _odometerController,
                  keyboardType: TextInputType.number,
                ),
                
                const SizedBox(height: 40),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        
                        // Construct the new vehicle map
                        final newVehicleData = {
                          'id': isEdit ? widget.vehicle!['id'] : DateTime.now().millisecondsSinceEpoch.toString(),
                          'name': '${_merkController.text} ${_tipeController.text}',
                          'type': _tipeController.text,
                          'year': _tahunController.text,
                          'plate': _nomorPolisiController.text,
                          'odometer': _odometerController.text,
                          'isActive': isEdit ? widget.vehicle!['isActive'] : true,
                          'statusMessage': isEdit ? widget.vehicle!['statusMessage'] : 'Aktif',
                          'lastService': isEdit ? widget.vehicle!['lastService'] : 'Belum pernah servis',
                        };

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isEdit ? 'Kendaraan berhasil diubah!' : 'Kendaraan berhasil ditambahkan!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        
                        // Return the data to previous screen
                        Navigator.pop(context, newVehicleData);
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
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              borderSide: const BorderSide(color: Color(0xFF5B61FF)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Mohon isi field ini';
            }
            return null;
          },
        ),
      ],
    );
  }
}
