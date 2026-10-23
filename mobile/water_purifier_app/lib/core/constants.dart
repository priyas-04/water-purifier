import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'AquaPure';
  static const String appTagline = 'Purity in Every Drop';
  
  // Brand Palette
  static const Color primaryBlue = Color(0xFF0A369D);
  static const Color accentCyan = Color(0xFF00B4D8);
  static const Color darkNavy = Color(0xFF041B3B);
  static const Color lightBlueBackground = Color(0xFFF0F7FD);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color dangerRed = Color(0xFFEF4444);

  // Dark Theme Palette
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);

  // Razorpay Test Credentials (Replace via secure remote config / build args in production)
  static const String razorpayTestKey = 'rzp_test_placeholder_key';

  // Demo Fallback Flag
  static const bool isDemoMode = true;

  // Categories
  static const List<Map<String, String>> categories = [
    {
      'id': 'all',
      'label': 'All Products',
      'icon': 'water_drop',
    },
    {
      'id': 'purifier',
      'label': 'Purifiers',
      'icon': 'sanitizer',
    },
    {
      'id': 'dispenser',
      'label': 'Dispensers',
      'icon': 'local_drink',
    },
    {
      'id': 'pump',
      'label': 'Booster Pumps',
      'icon': 'speed',
    },
    {
      'id': 'filter',
      'label': 'Filters & Cartridges',
      'icon': 'filter_alt',
    },
    {
      'id': 'spare_part',
      'label': 'Spare Parts',
      'icon': 'build',
    },
  ];

  static const List<String> serviceTypes = [
    'Installation',
    'Routine Maintenance',
    'Filter Replacement',
    'Leakage / Repair',
    'TDS / Water Quality Check',
  ];
}
