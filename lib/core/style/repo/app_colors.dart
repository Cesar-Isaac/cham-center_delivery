import 'package:flutter/material.dart';

/// Central color palette for the entire application.
/// All widgets and screens must reference colors from here.
abstract final class AppColors {
  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color bgDeep   = Color(0xFF0B1220);   // main scaffold
  static const Color bgCard   = Color(0xFF1A2535);   // cards / list tiles
  static const Color bgSheet  = Color(0xFF0F1923);   // bottom sheets / panels
  static const Color bgOverlay = Color(0xFF0B1220);  // transparent overlays base

  // ── Brand / Primary ────────────────────────────────────────────────────────
  static const Color primary      = Color(0xFF009688); // teal 500
  static const Color primaryLight = Color(0xFF64FFDA); // tealAccent
  static const Color primaryDark  = Color(0xFF00695C); // teal 800

  // ── Status ─────────────────────────────────────────────────────────────────
  static const Color online    = Color(0xFF4CAF50); // green
  static const Color offline   = Color(0xFFE53935); // red
  static const Color arrived   = Color(0xFF43A047); // green 700
  static const Color warning   = Color(0xFFFF9800); // orange
  static const Color delivered = Color(0xFF26A69A); // teal 400

  // ── Order categories ───────────────────────────────────────────────────────
  static const Color catClothing = Color(0xFF9C27B0); // purple
  static const Color catTech     = Color(0xFF1976D2); // blue
  static const Color catFood     = Color(0xFFFF9800); // orange

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // 70 % white
  static const Color textHint      = Color(0x61FFFFFF); // 38 % white
  static const Color textDisabled  = Color(0x38FFFFFF); // 22 % white

  // ── Dividers / Borders ─────────────────────────────────────────────────────
  static const Color divider    = Color(0x1AFFFFFF); // 10 % white
  static const Color borderSoft = Color(0x14FFFFFF); // 8 % white

  // ── Map markers ────────────────────────────────────────────────────────────
  static const Color markerDriver      = Color(0xFF009688);
  static const Color markerDestCurrent = Color(0xFFE53935); // current stop
  static const Color markerDestPending = Color(0xFFFF9800); // upcoming stop
  static const Color markerDelivered   = Color(0xFF43A047); // delivered stop
  static const Color routeLine         = Color(0xFF009688);

  // ── Map tiles ──────────────────────────────────────────────────────────────
  /// Google Maps roadmap tiles (for training/demo use).
  static const String mapTileUrl =
      'https://mt{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
  static const List<String> mapTileSubdomains = ['0', '1', '2', '3'];

  // ── Mall / base location ───────────────────────────────────────────────────
  /// شام سنتر، كفرسوسة، دمشق — driver starting point and return destination.
  static const double mallLat = 33.500659;
  static const double mallLng = 36.274265;
  static const String mallAddress = 'شام سيتي سنتر، كفرسوسة، دمشق';
}
