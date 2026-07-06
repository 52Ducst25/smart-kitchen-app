import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'neon_carbon_colors.dart';

/// Theme Neon-Carbon: Material 3. Có 2 biến thể [dark] (nền carbon, nhấn cyan)
/// và [light] (nền sáng, chữ đậm, cyan làm sâu). Cả hai gắn [NcPalette] để
/// widget đọc màu động qua `context.nc`.
///
/// Body dùng Exo 2; tiêu đề/số dùng Chakra Petch; dữ liệu/nhãn dùng JetBrains Mono.
class NeonCarbonTheme {
  NeonCarbonTheme._();

  static ThemeData get dark {
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
    return _build(Brightness.dark, scheme, NcPalette.dark);
  }

  static ThemeData get light {
    final palette = NcPalette.light;
    final scheme = ColorScheme.light(
      primary: palette.cyan,
      onPrimary: Colors.white,
      secondary: palette.cyanText,
      onSecondary: Colors.white,
      surface: palette.carbonPanel,
      onSurface: palette.white,
      error: palette.red,
      onError: Colors.white,
      outline: palette.carbonLine,
    );
    return _build(Brightness.light, scheme, palette);
  }

  /// Dựng ThemeData chung cho cả 2 biến thể (DRY) từ [scheme] + [palette].
  static ThemeData _build(
    Brightness brightness,
    ColorScheme scheme,
    NcPalette palette,
  ) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    return base.copyWith(
      colorScheme: scheme,
      extensions: [palette],
      scaffoldBackgroundColor: palette.carbon,
      canvasColor: palette.carbon,
      dividerColor: palette.carbonLine,
      dividerTheme: DividerThemeData(
        color: palette.carbonLine,
        thickness: 1,
        space: 1,
      ),
      textTheme: GoogleFonts.exo2TextTheme(base.textTheme).apply(
        bodyColor: palette.white,
        displayColor: palette.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.carbonPanel,
        foregroundColor: palette.white,
        elevation: 0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? palette.cyan
              : palette.whiteDim,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? palette.cyanDim
              : palette.carbonLineBright,
        ),
      ),
    );
  }
}

/// Kho text style kỹ thuật dùng lại toàn app (đúng type-scale của guideline §2).
///
/// [color] nay nhận `Color?`: nếu null → KHÔNG ép màu, chữ kế thừa màu ambient
/// (DefaultTextStyle theo theme) → tự thích ứng dark/light. Nơi cần màu cụ thể
/// thì truyền qua `context.nc.<token>`.
class NcText {
  NcText._();

  /// Số liệu lớn / card-value — Chakra Petch 700.
  static TextStyle value({double size = 34, Color? color}) =>
      GoogleFonts.chakraPetch(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.5,
      );

  /// Tiêu đề khu vực / vault — Chakra Petch 600.
  static TextStyle heading({double size = 20, Color? color}) =>
      GoogleFonts.chakraPetch(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.4,
      );

  /// Nhãn kỹ thuật nhỏ — UPPERCASE, JetBrains Mono, letter-spacing rộng.
  static TextStyle label({double size = 10, Color? color}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        color: color,
        letterSpacing: size * 0.2, // ~.2em
        fontWeight: FontWeight.w500,
      );

  /// Dữ liệu số dạng mono có tabular-nums (căn cột đều).
  static TextStyle mono({double size = 11, Color? color}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        color: color,
        letterSpacing: 0.5,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Body / mô tả — Exo 2 300.
  static TextStyle body({double size = 13, Color? color}) => GoogleFonts.exo2(
        fontSize: size,
        color: color,
        height: 1.6,
        fontWeight: FontWeight.w300,
      );
}
