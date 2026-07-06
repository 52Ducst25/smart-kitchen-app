import 'package:flutter/material.dart';

/// Bảng màu token Neon-Carbon (nguồn: neon-carbon/DESIGN-GUIDELINE.md §1).
///
/// Nguyên tắc: nền tối chiếm ~95% diện tích; cyan chỉ để "trỏ mắt" tới thông
/// tin quan trọng; green/red/amber CHỈ dùng cho trạng thái ngữ nghĩa.
/// Luôn dùng hằng số ở đây — không hard-code màu rải rác trong widget.
class NcColors {
  NcColors._();

  // --- Bề mặt tối (Velzon Material Dark) ---
  static const carbon = Color(0xFF1A1D21); // body-bg (nền trang)
  static const carbonUp = Color(0xFF2A2D31); // tertiary-bg (hover/lớp trong)
  static const carbonPanel = Color(0xFF212529); // secondary-bg (card/panel)
  static const carbonLine = Color(0xFF32383E); // border-color
  static const carbonLineBright = Color(0xFF3D444B); // border nổi hơn

  // --- Nhấn thương hiệu (primary tím Velzon) ---
  static const cyan = Color(0xFF4B38B3); // primary — nhấn chính, nút, active
  static const cyanText = Color(0xFFCFC9EE); // link/số liệu (tím rất nhạt)
  static const cyanDim = Color(0x264B38B3); // ~.15 nền soft (subtle)
  static const cyanGhost = Color(0x0F4B38B3); // ~.06 row hover
  static const cyanGlow = Color(0x334B38B3); // ~.2 (soft, hầu như không dùng)

  // --- Chữ & trạng thái ---
  static const white = Color(0xFFE9EBEE); // chữ chính / nhấn mạnh (emphasis)
  static const whiteDim = Color(0xFF878A99); // secondary-color (muted)
  static const green = Color(0xFF45CB85); // success
  static const red = Color(0xFFF06548); // danger
  static const amber = Color(0xFFFFBE0B); // warning

  // --- Màu phân biệt theo chỉ số (palette Velzon, dễ đọc trên nền tối) ---
  static const mTemp = Color(0xFFF06548); // Nhiệt độ — coral
  static const mHum = Color(0xFF299CDB); // Độ ẩm — info blue
  static const mGas = amber; // Khí gas — amber
  static const mSmoke = Color(0xFFF672A7); // Khói — pink
  static const mFlame = green; // Lửa — success green
}

/// Palette Neon-Carbon theo theme (dark/light), phát qua [ThemeExtension] để
/// widget đọc màu động qua `context.nc.<token>` thay vì hằng số tĩnh.
///
/// Tên field khớp [NcColors] → migrate 1-1: `NcColors.x` ⇒ `context.nc.x`.
/// Bản [dark] = đúng token gốc; bản [light] là biến thể sáng (nền sáng, chữ
/// đậm, cyan làm sâu để đủ tương phản trên nền trắng). Green/red/amber được
/// làm đậm hơn ở light để không bị "chói mờ" trên nền sáng.
@immutable
class NcPalette extends ThemeExtension<NcPalette> {
  const NcPalette({
    required this.carbon,
    required this.carbonUp,
    required this.carbonPanel,
    required this.carbonLine,
    required this.carbonLineBright,
    required this.cyan,
    required this.cyanText,
    required this.cyanDim,
    required this.cyanGhost,
    required this.cyanGlow,
    required this.white,
    required this.whiteDim,
    required this.green,
    required this.red,
    required this.amber,
    required this.mTemp,
    required this.mHum,
    required this.mGas,
    required this.mSmoke,
    required this.mFlame,
  });

  final Color carbon, carbonUp, carbonPanel, carbonLine, carbonLineBright;
  final Color cyan, cyanText, cyanDim, cyanGhost, cyanGlow;
  final Color white, whiteDim, green, red, amber;
  final Color mTemp, mHum, mGas, mSmoke, mFlame;

  /// Bản tối — dùng lại đúng token gốc trong [NcColors].
  static const dark = NcPalette(
    carbon: NcColors.carbon,
    carbonUp: NcColors.carbonUp,
    carbonPanel: NcColors.carbonPanel,
    carbonLine: NcColors.carbonLine,
    carbonLineBright: NcColors.carbonLineBright,
    cyan: NcColors.cyan,
    cyanText: NcColors.cyanText,
    cyanDim: NcColors.cyanDim,
    cyanGhost: NcColors.cyanGhost,
    cyanGlow: NcColors.cyanGlow,
    white: NcColors.white,
    whiteDim: NcColors.whiteDim,
    green: NcColors.green,
    red: NcColors.red,
    amber: NcColors.amber,
    mTemp: NcColors.mTemp,
    mHum: NcColors.mHum,
    mGas: NcColors.mGas,
    mSmoke: NcColors.mSmoke,
    mFlame: NcColors.mFlame,
  );

  /// Bản sáng (Velzon Material Light) — nền xám nhạt, card trắng, chữ đậm.
  static const light = NcPalette(
    carbon: Color(0xFFF2F2F7), // body-bg light
    carbonUp: Color(0xFFEFF2F7), // tertiary-bg light
    carbonPanel: Color(0xFFFFFFFF), // card/panel trắng
    carbonLine: Color(0xFFE9EBEC), // border light
    carbonLineBright: Color(0xFFDFE3E8), // border nổi
    cyan: Color(0xFF4B38B3), // primary tím
    cyanText: Color(0xFF4B38B3), // link/số liệu tím
    cyanDim: Color(0x1A4B38B3), // ~.10 soft bg
    cyanGhost: Color(0x0D4B38B3), // ~.05 row hover
    cyanGlow: Color(0x264B38B3), // soft
    white: Color(0xFF212529), // chữ chính (đậm)
    whiteDim: Color(0xFF878A99), // chữ phụ (muted)
    green: Color(0xFF45CB85),
    red: Color(0xFFF06548),
    amber: Color(0xFFFFBE0B),
    mTemp: Color(0xFFF06548),
    mHum: Color(0xFF299CDB),
    mGas: Color(0xFFF59E0B),
    mSmoke: Color(0xFFD63384),
    mFlame: Color(0xFF45CB85),
  );

  @override
  NcPalette copyWith({
    Color? carbon,
    Color? carbonUp,
    Color? carbonPanel,
    Color? carbonLine,
    Color? carbonLineBright,
    Color? cyan,
    Color? cyanText,
    Color? cyanDim,
    Color? cyanGhost,
    Color? cyanGlow,
    Color? white,
    Color? whiteDim,
    Color? green,
    Color? red,
    Color? amber,
    Color? mTemp,
    Color? mHum,
    Color? mGas,
    Color? mSmoke,
    Color? mFlame,
  }) {
    return NcPalette(
      carbon: carbon ?? this.carbon,
      carbonUp: carbonUp ?? this.carbonUp,
      carbonPanel: carbonPanel ?? this.carbonPanel,
      carbonLine: carbonLine ?? this.carbonLine,
      carbonLineBright: carbonLineBright ?? this.carbonLineBright,
      cyan: cyan ?? this.cyan,
      cyanText: cyanText ?? this.cyanText,
      cyanDim: cyanDim ?? this.cyanDim,
      cyanGhost: cyanGhost ?? this.cyanGhost,
      cyanGlow: cyanGlow ?? this.cyanGlow,
      white: white ?? this.white,
      whiteDim: whiteDim ?? this.whiteDim,
      green: green ?? this.green,
      red: red ?? this.red,
      amber: amber ?? this.amber,
      mTemp: mTemp ?? this.mTemp,
      mHum: mHum ?? this.mHum,
      mGas: mGas ?? this.mGas,
      mSmoke: mSmoke ?? this.mSmoke,
      mFlame: mFlame ?? this.mFlame,
    );
  }

  @override
  NcPalette lerp(ThemeExtension<NcPalette>? other, double t) {
    if (other is! NcPalette) return this;
    return NcPalette(
      carbon: Color.lerp(carbon, other.carbon, t)!,
      carbonUp: Color.lerp(carbonUp, other.carbonUp, t)!,
      carbonPanel: Color.lerp(carbonPanel, other.carbonPanel, t)!,
      carbonLine: Color.lerp(carbonLine, other.carbonLine, t)!,
      carbonLineBright: Color.lerp(carbonLineBright, other.carbonLineBright, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
      cyanText: Color.lerp(cyanText, other.cyanText, t)!,
      cyanDim: Color.lerp(cyanDim, other.cyanDim, t)!,
      cyanGhost: Color.lerp(cyanGhost, other.cyanGhost, t)!,
      cyanGlow: Color.lerp(cyanGlow, other.cyanGlow, t)!,
      white: Color.lerp(white, other.white, t)!,
      whiteDim: Color.lerp(whiteDim, other.whiteDim, t)!,
      green: Color.lerp(green, other.green, t)!,
      red: Color.lerp(red, other.red, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      mTemp: Color.lerp(mTemp, other.mTemp, t)!,
      mHum: Color.lerp(mHum, other.mHum, t)!,
      mGas: Color.lerp(mGas, other.mGas, t)!,
      mSmoke: Color.lerp(mSmoke, other.mSmoke, t)!,
      mFlame: Color.lerp(mFlame, other.mFlame, t)!,
    );
  }
}

/// Truy cập palette Neon-Carbon hiện hành: `context.nc.<token>`.
/// Fallback về [NcPalette.dark] nếu chưa gắn extension (an toàn khi test).
extension NcContext on BuildContext {
  NcPalette get nc =>
      Theme.of(this).extension<NcPalette>() ?? NcPalette.dark;
}
