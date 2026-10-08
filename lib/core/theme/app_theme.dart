import 'package:flutter/material.dart';

/// Brand colours: soft greens on warm neutrals. Contrast of every text pair is
/// checked in test/core/theme_contrast_test.dart (WCAG AA, 4.5:1).
class AppColors {
  const AppColors._();

  static const green = Color(0xFF2C6E49); // primary
  static const greenDark = Color(0xFF1E4D33);
  static const greenSoft = Color(0xFFDCEBDD); // selected / container
  static const cream = Color(0xFFFBF7EF); // page background
  static const card = Color(0xFFFFFFFF);
  static const ink = Color(0xFF1F2A22); // body text
  static const inkSoft = Color(0xFF4A5750); // secondary text
  static const outline = Color(0xFF7A877F);

  // Three-tier colours. Always shown together with an icon and a text label.
  static const inRangeFg = Color(0xFF1B5E37);
  static const inRangeBg = Color(0xFFDFF1E3);
  static const cautionFg = Color(0xFF6B4200);
  static const cautionBg = Color(0xFFFFEFC7);
  static const urgentFg = Color(0xFF8E1B1B);
  static const urgentBg = Color(0xFFFDE2E0);
}

/// Colours and icons for the three result tiers (Phase 3 uses these).
@immutable
class TierStyle {
  const TierStyle({required this.fg, required this.bg, required this.icon});
  final Color fg;
  final Color bg;
  final IconData icon;
}

class TierStyles extends ThemeExtension<TierStyles> {
  const TierStyles();

  final inRange = const TierStyle(
    fg: AppColors.inRangeFg,
    bg: AppColors.inRangeBg,
    icon: Icons.check_circle,
  );
  final outOfRange = const TierStyle(
    fg: AppColors.cautionFg,
    bg: AppColors.cautionBg,
    icon: Icons.warning_amber_rounded,
  );
  final urgent = const TierStyle(
    fg: AppColors.urgentFg,
    bg: AppColors.urgentBg,
    icon: Icons.error,
  );

  @override
  TierStyles copyWith() => this;

  @override
  TierStyles lerp(ThemeExtension<TierStyles>? other, double t) => this;
}

class AppTheme {
  const AppTheme._();

  static const double minTouch = 56;
  static const double bodySize = 18;

  static const _devanagari = 'NotoSansDevanagari';

  static ThemeData light({required bool nepali}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.green,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.green,
      onPrimary: Colors.white,
      primaryContainer: AppColors.greenSoft,
      onPrimaryContainer: AppColors.greenDark,
      surface: AppColors.cream,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.inkSoft,
      outline: AppColors.outline,
      error: AppColors.urgentFg,
      onError: Colors.white,
      errorContainer: AppColors.urgentBg,
      onErrorContainer: AppColors.urgentFg,
    );

    // Nepali text needs the Devanagari font first; English text falls back to
    // it so a Nepali name typed into an English UI still renders.
    final family = nepali ? _devanagari : null;
    final fallback = nepali ? const <String>[] : const [_devanagari];

    TextStyle s(double size, FontWeight w, {double height = 1.4}) => TextStyle(
          fontFamily: family,
          fontFamilyFallback: fallback,
          fontSize: size,
          fontWeight: w,
          height: height,
          color: AppColors.ink,
        );

    final text = TextTheme(
      displaySmall: s(34, FontWeight.w700, height: 1.25),
      headlineMedium: s(30, FontWeight.w700, height: 1.3),
      headlineSmall: s(26, FontWeight.w700, height: 1.3),
      titleLarge: s(24, FontWeight.w700, height: 1.3),
      titleMedium: s(20, FontWeight.w600),
      titleSmall: s(18, FontWeight.w600),
      bodyLarge: s(20, FontWeight.w400, height: 1.5),
      bodyMedium: s(bodySize, FontWeight.w400, height: 1.5),
      bodySmall: s(bodySize, FontWeight.w400, height: 1.5),
      labelLarge: s(20, FontWeight.w700),
      labelMedium: s(16, FontWeight.w600),
      labelSmall: s(16, FontWeight.w600),
    );

    const radius = 16.0;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );
    const buttonSize = Size(88, minTouch);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: text,
      fontFamily: family,
      fontFamilyFallback: fallback,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: const [TierStyles()],
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
        toolbarHeight: minTouch + 8,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: Color(0xFFD9D4C7)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: text.labelLarge,
          shape: shape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: text.labelLarge,
          foregroundColor: AppColors.greenDark,
          side: const BorderSide(color: AppColors.green, width: 2),
          shape: shape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonSize,
          textStyle: text.labelLarge,
          foregroundColor: AppColors.greenDark,
          shape: shape,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(minTouch, minTouch)),
      ),
      listTileTheme: ListTileThemeData(
        minTileHeight: minTouch,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        titleTextStyle: text.bodyLarge,
        subtitleTextStyle: text.bodyMedium?.copyWith(color: AppColors.inkSoft),
        shape: shape,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelStyle: text.bodyLarge?.copyWith(color: AppColors.inkSoft),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.outline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.green, width: 3),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 84,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.greenSoft,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => text.labelMedium?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 30,
            color: states.contains(WidgetState.selected)
                ? AppColors.greenDark
                : AppColors.inkSoft,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFD9D4C7)),
    );
  }
}
