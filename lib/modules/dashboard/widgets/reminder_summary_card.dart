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
    final iconData = _getIcon(reminder.category);
    final iconColor = _getIconColor(reminder.category);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getSubtitle(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String category) {
    switch (category) {
      case 'tax':
        return Icons.receipt_long_outlined;
      case 'oil':
        return Icons.opacity_outlined;
      default:
        return Icons.build_circle_outlined;
    }
  }

  Color _getIconColor(String category) {
    switch (category) {
      case 'tax':
        return const Color(0xFFF59E0B);
      case 'oil':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  String _getSubtitle() {
    if (reminder.category == 'tax') {
      final days = reminder.remainingDays;
      if (days == null) return reminder.description;
      if (days < 0) return 'Lewat ${days.abs()} hari yang lalu!';
      if (days == 0) return 'Jatuh tempo hari ini!';
      // Format as date like "12 Nov 2026"
      if (reminder.dueDate != null) {
        final d = reminder.dueDate!;
        final months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
        return '${d.day} ${months[d.month - 1]} ${d.year}';
      }
      return 'Tersisa $days hari lagi';
    } else {
      final km = reminder.remainingKm;
      if (km == null) return reminder.description;
      if (km < 0) return 'Lewat ${km.abs()} km yang lalu!';
      if (km == 0) return 'Waktunya servis sekarang!';
      return 'Dalam ${_formatKm(km)} km';
    }
  }

  String _formatKm(int km) {
    return km.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
