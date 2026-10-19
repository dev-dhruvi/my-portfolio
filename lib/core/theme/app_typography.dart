import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized typography rules for the portfolio.
class AppTypography {
  AppTypography._();

  static TextStyle getDisplayLarge(Color color) {
    return GoogleFonts.inter(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.2,
      height: 1.15,
      color: color,
    );
  }

  static TextStyle getDisplayMedium(Color color) {
    return GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.8,
      height: 1.2,
      color: color,
    );
  }

  static TextStyle getHeadline(Color color) {
    return GoogleFonts.inter(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.3,
      color: color,
    );
  }

  static TextStyle getTitleLarge(Color color) {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.35,
      color: color,
    );
  }

  static TextStyle getTitleMedium(Color color) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.4,
      color: color,
    );
  }

  static TextStyle getBodyLarge(Color color) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.6,
      color: color,
    );
  }

  static TextStyle getBodyMedium(Color color) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.55,
      color: color,
    );
  }

  static TextStyle getLabelSmall(Color color) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.4,
      color: color,
    );
  }

  static TextStyle getCode(Color color) {
    return GoogleFonts.jetBrainsMono(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: color,
    );
  }
}
