import 'package:flutter/material.dart';

/// Centralised color palette for the entire application.
///
/// All colors live here so they can be updated from a single place
/// (e.g. after a Figma design-token export).
///
/// Usage: `AppColors.primary`, `AppColors.fieldBorder`, etc.
abstract class AppColors {
  // ── Brand / Primary ────────────────────────────────
  static const Color primary = Color(0xFF4477AC);
  static const Color primaryLight = Color(0xFF2C3E50);

  // ── Accent / Links ─────────────────────────────────
  static const Color accent = Color(0xFF3B7BF6);

  // ── Background ─────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);

  // ── Text ───────────────────────────────────────────
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textHint = Color(0xFF999999);
  static const Color textMuted = Color(0xFF555555);
  static const Color textBody = Color(0xFF666666);

  // ── Input fields ───────────────────────────────────
  static const Color fieldBorder = Color(0xFFDDDDDD);
  static const Color fieldFill = Color(0xFFFFFFFF);

  // ── Status ─────────────────────────────────────────
  static const Color error = Color(0xFFFF5252); // redAccent
  static const Color success = Color(0xFF2E7D32);
  static const Color markerRed = Color(0xFFE53935);

  // ── Misc ───────────────────────────────────────────
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000); // black 10%
  static const Color shadowMedium = Color(0x1F000000); // black 12%
}
