import 'package:flutter/material.dart';
import '../models/reminder_model.dart';

class AddReminderSheet extends StatefulWidget {
  final Function(ReminderModel) onAdd;

  const AddReminderSheet({super.key, required this.onAdd});

  @override
  State<AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<AddReminderSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _kmController = TextEditingController();

  String _selectedCategory = 'service';
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final desc = _descController.text.trim();
      final km = int.tryParse(_kmController.text.replaceAll(RegExp(r'[^0-9]'), ''));

      final newReminder = ReminderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        category: _selectedCategory,
        vehicleName: 'Honda Vario 160 (B 4567 XYZ)',
        targetKm: _selectedCategory == 'service' ? (km ?? 16000) : null,
        currentKm: 14250,
        dueDate: _selectedCategory == 'tax' ? (_selectedDate ?? DateTime.now().add(const Duration(days: 60))) : null,
        status: 'safe',
        description: desc.isEmpty ? 'Jadwal servis / pajak rutin' : desc,
        isEnabled: true,
      );

      widget.onAdd(newReminder);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
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
                'Tambah Pengingat Baru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),

              // Category Selector
              Row(
                children: [
                  Expanded(
                    child: _CategoryChoiceChip(
                      label: 'Servis Berkala',
                      icon: Icons.build_circle_outlined,
                      isSelected: _selectedCategory == 'service',
                      onSelected: () => setState(() => _selectedCategory = 'service'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CategoryChoiceChip(
                      label: 'Pajak & STNK',
                      icon: Icons.assignment_outlined,
                      isSelected: _selectedCategory == 'tax',
                      onSelected: () => setState(() => _selectedCategory = 'tax'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Nama Pengingat',
                  hintText: _selectedCategory == 'service' ? 'Misal: Ganti Oli Gardan' : 'Misal: Pajak STNK 1 Tahunan',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.notifications_active_outlined),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Nama pengingat wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              // Conditional Field: Target KM or Due Date
              if (_selectedCategory == 'service') ...[
                TextFormField(
                  controller: _kmController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Target Kilometer (KM)',
                    hintText: 'Misal: 16000',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.speed),
                    suffixText: 'KM',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Target KM wajib diisi';
                    if (int.tryParse(v) == null) return 'Masukkan angka valid';
                    return null;
                  },
                ),
              ] else ...[
                InkWell(
                  onTap: _pickDate,
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
                        Row(
                          children: [
                            Icon(Icons.calendar_month, color: Colors.grey.shade700),
                            const SizedBox(width: 10),
                            Text(
                              _selectedDate == null
                                  ? 'Pilih Tanggal Jatuh Tempo'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedDate == null ? Colors.grey.shade600 : const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),

              // Description Field
              TextFormField(
                controller: _descController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Catatan Rekomendasi (Opsional)',
                  hintText: 'Misal: Gunakan oli SAE 10W-30',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Simpan Pengingat',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChoiceChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onSelected;

  const _CategoryChoiceChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB).withValues(alpha: 0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
