import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddVehiclePage extends StatefulWidget {
  final Map<String, dynamic>? vehicle;
  final List<String> existingPlates;

  const AddVehiclePage({super.key, this.vehicle, this.existingPlates = const []});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

/// Formatter that capitalizes the first letter of each word.
class _CapitalizeWordsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final words = text.split(' ');
    final capitalized = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');

    return TextEditingValue(
      text: capitalized,
      selection: TextSelection.collapsed(offset: capitalized.length),
    );
  }
}

/// TextInputFormatter for Indonesian plate numbers.
/// Enforces strict zones: [Letters 1-2] [Digits 1-4] [Letters 1-3]
/// Auto-uppercase, auto-spaces between zones, total max 10 chars (incl. spaces).
class _PlatFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove spaces and uppercase
    final raw = newValue.text.replaceAll(' ', '').toUpperCase();
    if (raw.isEmpty) return const TextEditingValue();

    final buffer = StringBuffer();
    int zone = 0; // 0=prefix letters, 1=digits, 2=suffix letters
    int prefixCount = 0;
    int digitCount = 0;
    int suffixCount = 0;

    for (int i = 0; i < raw.length; i++) {
      final ch = raw[i];
      final isLetter = RegExp(r'[A-Z]').hasMatch(ch);
      final isDigit = RegExp(r'[0-9]').hasMatch(ch);

      if (!isLetter && !isDigit) continue; // ignore invalid chars

      if (zone == 0) {
        // Prefix: only letters, max 2
        if (isLetter && prefixCount < 2) {
          buffer.write(ch);
          prefixCount++;
        } else if (isDigit) {
          // Transition to digit zone
          if (prefixCount == 0) continue; // need at least 1 letter prefix
          zone = 1;
          buffer.write(' ');
          buffer.write(ch);
          digitCount++;
        }
        // Ignore extra letters beyond 2
      } else if (zone == 1) {
        // Middle: only digits, max 4
        if (isDigit && digitCount < 4) {
          buffer.write(ch);
          digitCount++;
        } else if (isLetter) {
          // Transition to suffix zone
          if (digitCount == 0) continue; // need at least 1 digit
          zone = 2;
          buffer.write(' ');
          buffer.write(ch);
          suffixCount++;
        }
        // Ignore extra digits beyond 4
      } else if (zone == 2) {
        // Suffix: only letters, max 3
        if (isLetter && suffixCount < 3) {
          buffer.write(ch);
          suffixCount++;
        }
        // Ignore digits and extra letters in suffix
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
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
  bool _isSaving = false;
  bool _isDirty = false;

  // Regex for Indonesian plate format: 1-2 letters, space, 1-4 digits, optional (space + 1-3 letters)
  // Examples: B 1, B 12, BA 4321, BA 4321 KZ
  final _platRegex = RegExp(r'^[A-Z]{1,2}\s\d{1,4}(\s[A-Z]{1,3})?$');

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _merkController.text = widget.vehicle!['name'].toString().split(' ').first;
      _tipeController.text = widget.vehicle!['type'] ?? '';
      _tahunController.text = widget.vehicle!['year'] ?? '';
      _nomorPolisiController.text = widget.vehicle!['plate'] ?? '';
      _odometerController.text = widget.vehicle!['odometer'] ?? '';
    }

    // Mark form as dirty when any field changes
    for (final c in [_merkController, _tipeController, _tahunController, _nomorPolisiController, _odometerController]) {
      c.addListener(() {
        if (!_isDirty) setState(() => _isDirty = true);
      });
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

  Future<bool> _onWillPop() async {
    if (!_isDirty) return true;
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar tanpa menyimpan?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        content: const Text('Perubahan yang belum disimpan akan hilang.', style: TextStyle(fontSize: 14, color: Colors.black87)),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Ya, Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    return shouldLeave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final canLeave = await _onWillPop();
          if (canLeave && context.mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF6C4DFF),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            onPressed: () async {
              final canLeave = await _onWillPop();
              if (canLeave && context.mounted) Navigator.pop(context);
            },
          ),
          title: Text(
            isEdit ? 'Ubah Kendaraan' : 'Tambah Kendaraan',
            style: const TextStyle(
              color: Colors.white,
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
                      border: Border.all(color: Colors.indigo.shade100),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF6C4DFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ambil atau Unggah Foto\n(Opsional)',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.indigo, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Merk
                  _buildTextField(
                    label: 'Merk (Brand)',
                    hint: 'Contoh: Honda',
                    controller: _merkController,
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [_CapitalizeWordsFormatter()],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Merk wajib diisi';
                      if (value.trim().length < 2) return 'Merk minimal 2 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tipe
                  _buildTextField(
                    label: 'Tipe',
                    hint: 'Contoh: Scoopy',
                    controller: _tipeController,
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [_CapitalizeWordsFormatter()],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Tipe wajib diisi';
                      if (value.trim().length < 2) return 'Tipe minimal 2 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tahun
                  _buildTextField(
                    label: 'Tahun',
                    hint: 'Contoh: 2021',
                    controller: _tahunController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Tahun wajib diisi';
                      final year = int.tryParse(value.trim());
                      if (year == null) return 'Tahun harus berupa angka';
                      final maxYear = DateTime.now().year + 1;
                      if (year < 1900 || year > maxYear) return 'Tahun harus antara 1900 dan $maxYear';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Nomor Polisi — with auto-formatter
                  _buildTextField(
                    label: 'Nomor Polisi',
                    hint: 'Contoh: B 1 atau B 4321 KZ',
                    controller: _nomorPolisiController,
                    inputFormatters: [_PlatFormatter()],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Nomor polisi wajib diisi';
                      final v = value.trim().toUpperCase();
                      // Must have at least 1 letter prefix + space + 1 digit
                      if (!v.contains(' ')) return 'Format tidak valid. Contoh: B 1 atau B 4321 KZ';
                      if (RegExp(r'^[A-Z\s]+$').hasMatch(v)) return 'Format tidak valid. Contoh: B 1 atau B 4321 KZ';
                      if (!_platRegex.hasMatch(v)) return 'Format tidak valid. Contoh: B 1 atau B 4321 KZ';
                      final currentPlate = isEdit ? (widget.vehicle!['plate'] ?? '').toString().toUpperCase().replaceAll(' ', '') : '';
                      final normalizedInput = v.replaceAll(' ', '');
                      for (final plate in widget.existingPlates) {
                        final normalizedExisting = plate.toUpperCase().replaceAll(' ', '');
                        if (normalizedExisting == normalizedInput && normalizedExisting != currentPlate) {
                          return 'Nomor polisi sudah terdaftar';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Odometer
                  _buildTextField(
                    label: 'Odometer Terakhir (km)',
                    hint: 'Contoh: 12490',
                    controller: _odometerController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Odometer wajib diisi';
                      final odometer = int.tryParse(value.trim());
                      if (odometer == null) return 'Odometer harus berupa angka';
                      if (odometer < 0) return 'Odometer tidak boleh negatif';
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // Save Button with loading state
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => _isSaving = true);

                                // Capture context-dependent objects before async gap
                                final messenger = ScaffoldMessenger.of(context);
                                final nav = Navigator.of(context);

                                // Simulate brief async (e.g., future DB call)
                                await Future.delayed(const Duration(milliseconds: 400));

                                final newVehicleData = {
                                  'id': isEdit ? widget.vehicle!['id'] : DateTime.now().millisecondsSinceEpoch.toString(),
                                  'name': '${_merkController.text.trim()} ${_tipeController.text.trim()}',
                                  'type': _tipeController.text.trim(),
                                  'year': _tahunController.text.trim(),
                                  'plate': _nomorPolisiController.text.trim().toUpperCase(),
                                  'odometer': _odometerController.text.trim(),
                                  'isActive': isEdit ? widget.vehicle!['isActive'] : true,
                                  'statusMessage': isEdit ? widget.vehicle!['statusMessage'] : 'Aktif',
                                  'lastService': isEdit ? widget.vehicle!['lastService'] : 'Belum pernah servis',
                                };

                                if (!mounted) return;
                                setState(() => _isDirty = false);

                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(isEdit ? 'Kendaraan berhasil diubah!' : 'Kendaraan berhasil ditambahkan!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                nav.pop(newVehicleData);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C4DFF),
                        disabledBackgroundColor: const Color(0xFF6C4DFF).withValues(alpha: 0.6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Text(
                              'Simpan',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
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
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
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
            errorStyle: const TextStyle(fontSize: 12, height: 1.4),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
