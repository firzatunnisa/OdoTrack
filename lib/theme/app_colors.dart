import 'package:flutter/material.dart';

/// Centralized color palette for OdoTrack application.
/// Modify colors here to change the look and feel across the entire app.
class AppColors {
  AppColors._();

  // Primary Brand Colors (Ungu OdoTrack)
  static const Color primary = Color(0xFF6C4DFF);
  static const Color primaryDark = Color(0xFF5538EE);
  static const Color primaryLight = Color(0xFFF3F0FF);
  static const Color primarySubtle = Color(0x146C4DFF); // 8% opacity

  // Functional / Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color secondary = success;
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFFE0F2FE);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;

  // Typography / Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFE5E7EB);

  // Bottom Navigation Bar
  static const Color navSelected = primary;
  static const Color navUnselected = Color(0xFF94A3B8);
}
