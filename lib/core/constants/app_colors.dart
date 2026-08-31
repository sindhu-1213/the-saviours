import 'package:flutter/material.dart';

class AppColors {
  // Spotify-Inspired Dark Canvas
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceElevated = Color(0xFF282828);
  static const Color surfaceHighlight = Color(0xFF333333);
  static const Color divider = Color(0xFF2A2A2A);

  // Accents
  static const Color primaryGreen = Color(0xFF1DB954); // Spotify Green
  static const Color greenLight = Color(0xFF1ED760);
  static const Color greenDark = Color(0xFF15883E);

  // Emergency & Status Semantics
  static const Color emergencyRed = Color(0xFFE53935); // Critical / SOS / Rejection
  static const Color redLight = Color(0xFFFF5252);
  static const Color warningOrange = Color(0xFFF2A93B); // Pending / Medium Severity
  static const Color infoBlue = Color(0xFF2979FF); // Normal route / Dispatch
  static const Color corridorGreen = Color(0xFF00E676); // Cleared Green Corridor

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textMuted = Color(0xFF757575);
  static const Color textDark = Color(0xFF121212);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF282828), Color(0xFF1E1E1E)],
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
  );

  static const LinearGradient corridorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1DB954), Color(0xFF00897B)],
  );
}
