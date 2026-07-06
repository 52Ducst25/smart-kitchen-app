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
      primary: NcColors.cyan, // tím Velzon
      onPrimary: Colors.white,
      secondary: Color(0xFF3577F1), // secondary xanh Velzon
      onSecondary: Colors.white,
      surface: NcColors.carbonPanel,
      onSurface: NcColors.white,
      error: NcColors.red,
      onError: Colors.white,
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
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
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

/// Kho text style dùng lại toàn app — nay theo Velzon Material: font **Inter**,
/// body ~13px, weight vừa phải, letter-spacing hẹp (bỏ phong cách HUD mono/rộng).
///
/// [color] nhận `Color?`: null → không ép màu, chữ kế thừa màu ambient
/// (DefaultTextStyle theo theme) → tự thích ứng dark/light.
class NcText {
  NcText._();

  /// Số liệu lớn / counter — Inter semibold.
  static TextStyle value({double size = 24, Color? color}) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: -0.2,
      );

  /// Tiêu đề khu vực / card-title — Inter semibold.
  static TextStyle heading({double size = 16, Color? color}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: -0.1,
      );

  /// Nhãn nhỏ (overline) — Inter medium, letter-spacing nhẹ.
  static TextStyle label({double size = 11, Color? color}) => GoogleFonts.inter(
        fontSize: size,
        color: color,
        letterSpacing: 0.3,
        fontWeight: FontWeight.w500,
      );

  /// Số liệu inline có tabular-nums (căn cột đều) — Inter.
  static TextStyle mono({double size = 12, Color? color}) => GoogleFonts.inter(
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w500,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Body / mô tả — Inter 400.
  static TextStyle body({double size = 13, Color? color}) => GoogleFonts.inter(
        fontSize: size,
        color: color,
        height: 1.5,
        fontWeight: FontWeight.w400,
      );
}
