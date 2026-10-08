import 'package:flutter/material.dart';
import '../models/reminder_model.dart';

class ReminderSummaryCard extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onTap;

  const ReminderSummaryCard({
    super.key,
    required this.reminder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(reminder.status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusConfig.borderColor),
          boxShadow: [
            BoxShadow(
              color: statusConfig.color.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon indicator
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusConfig.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                reminder.category == 'tax' ? Icons.description_outlined : Icons.build_outlined,
                color: statusConfig.color,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          reminder.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusConfig.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusConfig.label,
                          style: TextStyle(
                            color: statusConfig.color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        reminder.category == 'tax' ? Icons.calendar_today : Icons.speed,
                        size: 13,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getDetailSubtitle(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _getDetailSubtitle() {
    if (reminder.category == 'tax') {
      final days = reminder.remainingDays;
      if (days == null) return reminder.description;
      if (days < 0) return 'Lewat ${days.abs()} hari yang lalu!';
      if (days == 0) return 'Jatuh tempo hari ini!';
      return 'Tersisa $days hari lagi';
    } else {
      final km = reminder.remainingKm;
      if (km == null) return reminder.description;
      if (km < 0) return 'Lewat ${km.abs()} km yang lalu!';
      if (km == 0) return 'Waktunya servis sekarang!';
      return 'Tersisa $km km lagi (${reminder.targetKm} km)';
    }
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
