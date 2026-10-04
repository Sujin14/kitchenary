import 'package:flutter/material.dart';

/// The single source of truth for every colour in Kitchenary.
///
/// Rules:
///  * Raw colour values live ONLY in this file.
///  * Widgets read colours with `context.palette` (see
///    `core/extensions/context_extensions.dart`) so light and dark themes work
///    everywhere. Never use `Colors.*` or `Color(0x...)` outside this file.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.primary,
    required this.onPrimary,
    required this.primarySoft,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.error,
    required this.onError,
    required this.success,
    required this.easyBackground,
    required this.easyForeground,
    required this.mediumBackground,
    required this.mediumForeground,
    required this.hardBackground,
    required this.hardForeground,
    required this.veganBackground,
    required this.veganForeground,
    required this.timeBackground,
    required this.timeForeground,
    required this.vegMark,
    required this.nonVegMark,
    required this.cookingBackground,
    required this.cookingText,
    required this.cookingAccent,
    required this.cookingTrack,
    required this.scrim,
    required this.overlayControl,
    required this.shadow,
  });

  // Brand
  final Color primary;
  final Color onPrimary;
  final Color primarySoft;
  final Color accent;
  final Color onAccent;
  final Color accentSoft;

  // Surfaces
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color outline;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;

  // Status
  final Color error;
  final Color onError;
  final Color success;

  // Colour-coded metadata
  final Color easyBackground;
  final Color easyForeground;
  final Color mediumBackground;
  final Color mediumForeground;
  final Color hardBackground;
  final Color hardForeground;
  final Color veganBackground;
  final Color veganForeground;
  final Color timeBackground;
  final Color timeForeground;

  /// Indian packaging convention: green dot = veg, red/brown dot = non-veg.
  final Color vegMark;
  final Color nonVegMark;

  // Cooking mode: maximum contrast (WCAG AAA) for reading from 3 feet.
  final Color cookingBackground;
  final Color cookingText;
  final Color cookingAccent;
  final Color cookingTrack;

  // Overlays
  final Color scrim;
  final Color overlayControl;
  final Color shadow;

  // ---------------------------------------------------------------------
  // Palettes
  // ---------------------------------------------------------------------

  static const AppPalette light = AppPalette(
    primary: Color(0xFF2E5A44),
    onPrimary: Color(0xFFFDFBF7),
    primarySoft: Color(0xFFE3EEE7),
    accent: Color(0xFFE07A5F),
    onAccent: Color(0xFF1E2923),
    accentSoft: Color(0xFFFBE6DF),
    background: Color(0xFFFDFBF7),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF3EFE7),
    outline: Color(0xFFE2DDD2),
    textPrimary: Color(0xFF1E2923),
    textSecondary: Color(0xFF55615A),
    textHint: Color(0xFF7C867F),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    success: Color(0xFF2E7D4F),
    easyBackground: Color(0xFFDFF0E3),
    easyForeground: Color(0xFF1F5B33),
    mediumBackground: Color(0xFFFBEFC6),
    mediumForeground: Color(0xFF6B4E00),
    hardBackground: Color(0xFFFAD9D5),
    hardForeground: Color(0xFF8C1D18),
    veganBackground: Color(0xFFDCEBDD),
    veganForeground: Color(0xFF2B5B3A),
    timeBackground: Color(0xFFDDE7F0),
    timeForeground: Color(0xFF284A66),
    vegMark: Color(0xFF2E9B52),
    nonVegMark: Color(0xFFB3261E),
    cookingBackground: Color(0xFFFDFBF7),
    cookingText: Color(0xFF1D242B),
    cookingAccent: Color(0xFF8A3B25),
    cookingTrack: Color(0xFFD9D4C8),
    scrim: Color(0x99000000),
    overlayControl: Color(0xE6FFFFFF),
    shadow: Color(0x1F1E2923),
  );

  static const AppPalette dark = AppPalette(
    primary: Color(0xFF8CC3A4),
    onPrimary: Color(0xFF0F1A14),
    primarySoft: Color(0xFF22332A),
    accent: Color(0xFFF0937A),
    onAccent: Color(0xFF1A1410),
    accentSoft: Color(0xFF3A2620),
    background: Color(0xFF121714),
    surface: Color(0xFF1B231F),
    surfaceMuted: Color(0xFF242E29),
    outline: Color(0xFF34403A),
    textPrimary: Color(0xFFEDEAE3),
    textSecondary: Color(0xFFB4BCB6),
    textHint: Color(0xFF8A948D),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    success: Color(0xFF7FCFA0),
    easyBackground: Color(0xFF1F3B29),
    easyForeground: Color(0xFFA6E0B8),
    mediumBackground: Color(0xFF43370D),
    mediumForeground: Color(0xFFF2D77A),
    hardBackground: Color(0xFF4A1F1B),
    hardForeground: Color(0xFFF5B5AF),
    veganBackground: Color(0xFF1F3B2A),
    veganForeground: Color(0xFFA6E0B8),
    timeBackground: Color(0xFF1F3347),
    timeForeground: Color(0xFFA9CBEA),
    vegMark: Color(0xFF55C27B),
    nonVegMark: Color(0xFFE5675F),
    cookingBackground: Color(0xFF0B0F0D),
    cookingText: Color(0xFFF7F4EC),
    cookingAccent: Color(0xFFFFB59E),
    cookingTrack: Color(0xFF3A443F),
    scrim: Color(0xB3000000),
    overlayControl: Color(0xE61B231F),
    shadow: Color(0x66000000),
  );

  // ---------------------------------------------------------------------
  // ThemeExtension plumbing
  // ---------------------------------------------------------------------

  @override
  AppPalette copyWith({Color? primary, Color? accent}) => AppPalette(
        primary: primary ?? this.primary,
        onPrimary: onPrimary,
        primarySoft: primarySoft,
        accent: accent ?? this.accent,
        onAccent: onAccent,
        accentSoft: accentSoft,
        background: background,
        surface: surface,
        surfaceMuted: surfaceMuted,
        outline: outline,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        textHint: textHint,
        error: error,
        onError: onError,
        success: success,
        easyBackground: easyBackground,
        easyForeground: easyForeground,
        mediumBackground: mediumBackground,
        mediumForeground: mediumForeground,
        hardBackground: hardBackground,
        hardForeground: hardForeground,
        veganBackground: veganBackground,
        veganForeground: veganForeground,
        timeBackground: timeBackground,
        timeForeground: timeForeground,
        vegMark: vegMark,
        nonVegMark: nonVegMark,
        cookingBackground: cookingBackground,
        cookingText: cookingText,
        cookingAccent: cookingAccent,
        cookingTrack: cookingTrack,
        scrim: scrim,
        overlayControl: overlayControl,
        shadow: shadow,
      );

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      primary: mix(primary, other.primary),
      onPrimary: mix(onPrimary, other.onPrimary),
      primarySoft: mix(primarySoft, other.primarySoft),
      accent: mix(accent, other.accent),
      onAccent: mix(onAccent, other.onAccent),
      accentSoft: mix(accentSoft, other.accentSoft),
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceMuted: mix(surfaceMuted, other.surfaceMuted),
      outline: mix(outline, other.outline),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textHint: mix(textHint, other.textHint),
      error: mix(error, other.error),
      onError: mix(onError, other.onError),
      success: mix(success, other.success),
      easyBackground: mix(easyBackground, other.easyBackground),
      easyForeground: mix(easyForeground, other.easyForeground),
      mediumBackground: mix(mediumBackground, other.mediumBackground),
      mediumForeground: mix(mediumForeground, other.mediumForeground),
      hardBackground: mix(hardBackground, other.hardBackground),
      hardForeground: mix(hardForeground, other.hardForeground),
      veganBackground: mix(veganBackground, other.veganBackground),
      veganForeground: mix(veganForeground, other.veganForeground),
      timeBackground: mix(timeBackground, other.timeBackground),
      timeForeground: mix(timeForeground, other.timeForeground),
      vegMark: mix(vegMark, other.vegMark),
      nonVegMark: mix(nonVegMark, other.nonVegMark),
      cookingBackground: mix(cookingBackground, other.cookingBackground),
      cookingText: mix(cookingText, other.cookingText),
      cookingAccent: mix(cookingAccent, other.cookingAccent),
      cookingTrack: mix(cookingTrack, other.cookingTrack),
      scrim: mix(scrim, other.scrim),
      overlayControl: mix(overlayControl, other.overlayControl),
      shadow: mix(shadow, other.shadow),
    );
  }
}
