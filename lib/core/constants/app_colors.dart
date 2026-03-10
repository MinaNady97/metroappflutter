import 'package:flutter/material.dart';

/// Single source of truth for all app colors.
/// Import this instead of duplicating color definitions in every widget.
abstract final class AppColors {
  // Brand palette
  static const Color primary = Color(0xFF1A6F8F);    // Deep Nile Blue
  static const Color secondary = Color(0xFF029692);   // Teal
  static const Color accent = Color(0xFFD4AF37);      // Egyptian Gold
  static const Color background = Color(0xFFF5F5F5);  // Light Sand
  static const Color card = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF333333);        // Dark Gray

  // Metro line colors (official Cairo Metro palette)
  static const Color line1 = Color(0xFFAD1F52);  // Red   – Helwan ↔ New El-Marg
  static const Color line2 = Color(0xFF029692);  // Teal  – El-Mounib ↔ Shubra El-Kheima
  static const Color line3 = Color(0xFF008800);  // Green – Adly Mansour ↔ branches

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Crowd levels
  static const Color crowdLow = Color(0xFF4CAF50);
  static const Color crowdMedium = Color(0xFFFFC107);
  static const Color crowdHigh = Color(0xFFF44336);
}
