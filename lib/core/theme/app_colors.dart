import 'package:flutter/material.dart';

/// Centralized color palette defining the modern purple & obsidian aesthetic
/// with frosted glassmorphism, electric violet, and cyan accents.
class AppColors {
  AppColors._();

  // Dark Theme Backgrounds & Surfaces (Obsidian & Cosmic Purple)
  static const Color darkBackground = Color(0xFF090D16);
  static const Color darkCanvas = Color(0xFF0A0416);
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF131D31);
  static const Color darkCardHover = Color(0xFF18243E);
  static const Color darkCardBorder = Color(0x1FFFFFFF);
  static const Color darkCardBorderHover = Color(0x408B5CF6);

  // Frosted Glass & Showcase Styling (Dark)
  static const Color darkGlassBackground = Color(0xD90D071E);
  static const Color darkGlassBorder = Color(0x4D8B5CF6);
  static const Color darkShowcaseBorder = Color(0x338B5CF6);

  // Violet Accents
  static const Color violetPrimary = Color(0xFF8B5CF6);
  static const Color violetLight = Color(0xFFA78BFA);
  static const Color violetDark = Color(0xFF6D28D9);
  static const Color violetGlow = Color(0x4D8B5CF6);
  static const Color neonPurple = Color(0xFFA855F7);
  static const Color neonPurpleGlow = Color(0x668B5CF6);

  // Cyan & Electric Blue Accents
  static const Color cyanPrimary = Color(0xFF06B6D4);
  static const Color cyanLight = Color(0xFF22D3EE);
  static const Color cyanDark = Color(0xFF0891B2);
  static const Color cyanGlow = Color(0x4D06B6D4);

  static const Color bluePrimary = Color(0xFF3B82F6);
  static const Color blueLight = Color(0xFF60A5FA);

  // Dark Text & Icon Colors
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);

  // Light Theme Equivalents (Frosted Lavender Canvas)
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightCanvas = Color(0xFFFAF9FE);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardHover = Color(0xFFF1F5F9);
  static const Color lightCardBorder = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);

  // Frosted Glass & Showcase Styling (Light)
  static const Color lightGlassBackground = Color(0xEBFFFFFF);
  static const Color lightGlassBorder = Color(0x298B5CF6);
  static const Color lightShowcaseBorder = Color(0x1F8B5CF6);

  // Feedback & Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color onlineGreen = Color(0xFF10B981);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [violetPrimary, cyanPrimary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF9061F9), Color(0xFF7E3AF2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGlowGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xCC131D31), Color(0x990F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
