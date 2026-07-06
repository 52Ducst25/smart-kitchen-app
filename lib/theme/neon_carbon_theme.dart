import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'neon_carbon_colors.dart';

/// Theme tối Neon-Carbon: Material 3, nền carbon, nhấn cyan.
/// Body dùng Exo 2; tiêu đề/số dùng Chakra Petch; dữ liệu/nhãn dùng JetBrains Mono.
class NeonCarbonTheme {
  NeonCarbonTheme._();

  static ThemeData get dark {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
    const scheme = ColorScheme.dark(
      primary: NcColors.cyan,
      onPrimary: NcColors.carbon,
      secondary: NcColors.cyanText,
      onSecondary: NcColors.carbon,
      surface: NcColors.carbonPanel,
      onSurface: NcColors.white,
      error: NcColors.red,
      onError: NcColors.carbon,
      outline: NcColors.carbonLine,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: NcColors.carbon,
      canvasColor: NcColors.carbon,
      dividerColor: NcColors.carbonLine,
      dividerTheme: const DividerThemeData(
        color: NcColors.carbonLine,
        thickness: 1,
        space: 1,
      ),
      textTheme: GoogleFonts.exo2TextTheme(
        base.textTheme,
      ).apply(bodyColor: NcColors.white, displayColor: NcColors.white),
      appBarTheme: const AppBarTheme(
        backgroundColor: NcColors.carbonPanel,
        foregroundColor: NcColors.white,
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? NcColors.cyan
              : NcColors.whiteDim,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? NcColors.cyanDim
              : NcColors.carbonLineBright,
        ),
      ),
    );
  }
}

/// Kho text style kỹ thuật dùng lại toàn app (đúng type-scale của guideline §2).
class NcText {
  NcText._();

  /// Số liệu lớn / card-value — Chakra Petch 700.
  static TextStyle value({double size = 34, Color color = NcColors.white}) =>
      GoogleFonts.chakraPetch(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.5,
      );

  /// Tiêu đề khu vực / vault — Chakra Petch 600.
  static TextStyle heading({double size = 20, Color color = NcColors.white}) =>
      GoogleFonts.chakraPetch(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.4,
      );

  /// Nhãn kỹ thuật nhỏ — UPPERCASE, JetBrains Mono, letter-spacing rộng.
  static TextStyle label({double size = 10, Color color = NcColors.whiteDim}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        color: color,
        letterSpacing: size * 0.2, // ~.2em
        fontWeight: FontWeight.w500,
      );

  /// Dữ liệu số dạng mono có tabular-nums (căn cột đều).
  static TextStyle mono({double size = 11, Color color = NcColors.cyanText}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        color: color,
        letterSpacing: 0.5,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Body / mô tả — Exo 2 300.
  static TextStyle body({double size = 13, Color color = NcColors.whiteDim}) =>
      GoogleFonts.exo2(
        fontSize: size,
        color: color,
        height: 1.6,
        fontWeight: FontWeight.w300,
      );
}
