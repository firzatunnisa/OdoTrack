import 'package:flutter/material.dart';
import '../models/reminder_model.dart';

class ReminderItemCard extends StatelessWidget {
  final ReminderModel reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onMarkDone;
  final VoidCallback onEdit;

  const ReminderItemCard({
    super.key,
    required this.reminder,
    required this.onToggle,
    required this.onMarkDone,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(reminder.status);
    final isTax = reminder.category == 'tax';

    // Calculate progress (0.0 to 1.0)
    double progress = 0.5;
    if (isTax && reminder.dueDate != null) {
      final days = reminder.remainingDays ?? 0;
      if (days <= 0) {
        progress = 1.0;
      } else if (days > 365) {
        progress = 0.1;
      } else {
        progress = (365 - days) / 365;
      }
    } else if (reminder.targetKm != null && reminder.currentKm != null) {
      const totalInterval = 4000; // standard estimation interval
      final remaining = reminder.remainingKm ?? 0;
      if (remaining <= 0) {
        progress = 1.0;
      } else {
        progress = ((totalInterval - remaining) / totalInterval).clamp(0.0, 1.0);
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: reminder.isEnabled ? statusConfig.borderColor : Colors.grey.shade300,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: reminder.isEnabled
                ? statusConfig.color.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Opacity(
        opacity: reminder.isEnabled ? 1.0 : 0.6,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon + Title + Switch
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusConfig.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isTax ? Icons.assignment_outlined : Icons.build_outlined,
                      color: statusConfig.color,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          reminder.vehicleName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: reminder.isEnabled,
                    activeTrackColor: statusConfig.color,
                    onChanged: onToggle,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description / note
              Text(
                reminder.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 14),

              // Progress & Status Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getProgressDetailText(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusConfig.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusConfig.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusConfig.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(statusConfig.color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              const Divider(height: 1),
              const SizedBox(height: 10),

              // Action buttons footer
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onEdit,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Atur', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: onMarkDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: statusConfig.color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text(
                      'Selesai',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getProgressDetailText() {
    if (reminder.category == 'tax') {
      final days = reminder.remainingDays;
      if (days == null) return 'Jadwal belum ditentukan';
      if (days < 0) return 'Lewat ${days.abs()} hari (${_formatDate(reminder.dueDate!)})';
      if (days == 0) return 'Jatuh tempo HARI INI!';
      return 'Sisa $days hari lagi (${_formatDate(reminder.dueDate!)})';
    } else {
      final km = reminder.remainingKm;
      if (km == null) return 'Target KM belum diisi';
      if (km < 0) return 'Lewat ${km.abs()} km (Target: ${reminder.targetKm} km)';
      if (km == 0) return 'Ganti sekarang (Target: ${reminder.targetKm} km)';
      return 'Sisa $km km lagi (Target: ${reminder.targetKm} km)';
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status) {
      case 'critical':
        return _StatusConfig(
          label: 'Mendesak',
          color: const Color(0xFFEF4444),
          borderColor: const Color(0xFFFCA5A5),
        );
      case 'warning':
        return _StatusConfig(
          label: 'Segera',
          color: const Color(0xFFF59E0B),
          borderColor: const Color(0xFFFDE68A),
        );
      default:
        return _StatusConfig(
          label: 'Aman',
          color: const Color(0xFF10B981),
          borderColor: const Color(0xFFA7F3D0),
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final Color borderColor;

  _StatusConfig({
    required this.label,
    required this.color,
    required this.borderColor,
  });
}
