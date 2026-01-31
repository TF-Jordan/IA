import 'package:flutter/material.dart';

/// Centralized color palette for the CHF application.
///
/// Each theme variant defines exactly 5 semantic colors:
///   - primary     : Main brand color (buttons, appbar, links)
///   - secondary   : Accent / highlight color (badges, icons, decorations)
///   - background  : Scaffold / page background
///   - surface     : Card / container background
///   - accent      : Tertiary color for subtle highlights & success states
///
/// An additional set of neutral / utility colors is shared across themes.
class AppColors {
  AppColors._();

  // ──────────────────────────────────────────────
  //  LIGHT THEME  –  Pure, spiritual, trustworthy
  // ──────────────────────────────────────────────
  static const Color lightPrimary = Color(0xFF1B3A5C);
  static const Color lightSecondary = Color(0xFFD4A843);
  static const Color lightBackground = Color(0xFFFAFBFD);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightAccent = Color(0xFF2E7D6F);

  // ──────────────────────────────────────────────
  //  DARK THEME  –  Elegant, immersive, restful
  // ──────────────────────────────────────────────
  static const Color darkPrimary = Color(0xFF7EB8E0);
  static const Color darkSecondary = Color(0xFFE8C96A);
  static const Color darkBackground = Color(0xFF0F1923);
  static const Color darkSurface = Color(0xFF1A2733);
  static const Color darkAccent = Color(0xFF4ECDC4);

  // ──────────────────────────────────────────────
  //  OCEAN THEME  –  Fresh, open, calming
  // ──────────────────────────────────────────────
  static const Color oceanPrimary = Color(0xFF0077B6);
  static const Color oceanSecondary = Color(0xFFF4A261);
  static const Color oceanBackground = Color(0xFFF0F7FA);
  static const Color oceanSurface = Color(0xFFFFFFFF);
  static const Color oceanAccent = Color(0xFF00B4D8);

  // ──────────────────────────────────────────────
  //  SHARED UTILITY COLORS
  // ──────────────────────────────────────────────
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF9A825);
  static const Color info = Color(0xFF1976D2);

  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textMedium = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textOnDark = Color(0xFFF9FAFB);

  static const Color divider = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF2D3748);

  static const Color shimmer = Color(0xFFE0E0E0);
}
