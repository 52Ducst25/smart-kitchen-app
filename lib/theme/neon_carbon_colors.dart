import 'package:flutter/material.dart';

/// Bảng màu token Neon-Carbon (nguồn: neon-carbon/DESIGN-GUIDELINE.md §1).
///
/// Nguyên tắc: nền tối chiếm ~95% diện tích; cyan chỉ để "trỏ mắt" tới thông
/// tin quan trọng; green/red/amber CHỈ dùng cho trạng thái ngữ nghĩa.
/// Luôn dùng hằng số ở đây — không hard-code màu rải rác trong widget.
class NcColors {
  NcColors._();

  // --- Carbon scale (nền) ---
  static const carbon = Color(0xFF08090A); // nền gốc (body, card)
  static const carbonUp = Color(0xFF0E1012); // nền hover (card raised)
  static const carbonPanel = Color(0xFF0C0D0F); // panel / sidebar
  static const carbonLine = Color(0xFF1A1D22); // border mặc định, gap grid
  static const carbonLineBright = Color(0xFF252930); // border nổi hơn

  // --- Cyan (nhấn thương hiệu) ---
  static const cyan = Color(0xFF00F0FF); // nhấn chính, viền active, glow
  static const cyanText = Color(0xFF7DF7FF); // chữ cyan dịu (số liệu)
  static const cyanDim = Color(0x1F00F0FF); // ~.12 alpha (active bg, chip)
  static const cyanGhost = Color(0x0A00F0FF); // ~.04 (row hover)
  static const cyanGlow = Color(0x4D00F0FF); // ~.3 (box-shadow phát sáng)

  // --- Chữ & trạng thái ---
  static const white = Color(0xFFE8ECF0); // chữ chính
  static const whiteDim = Color(0xFF8A8F99); // chữ phụ, mô tả, nhãn
  static const green = Color(0xFF00FF6A); // success / online / an toàn
  static const red = Color(0xFFFF3B4E); // error / critical / nguy hiểm
  static const amber = Color(0xFFFFB300); // warning / cần chú ý

  // --- Màu phân biệt theo chỉ số (mỗi thông số 1 màu, dễ đọc thẻ & biểu đồ) ---
  static const mTemp = cyan; // Nhiệt độ — cyan
  static const mHum = Color(0xFF4D96FF); // Độ ẩm — xanh dương
  static const mGas = amber; // Khí gas — hổ phách
  static const mSmoke = Color(0xFFB388FF); // Khói — tím
  static const mFlame = green; // Lửa — xanh lá (an toàn)
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

  /// Bản sáng — nền sáng, chữ đậm, cyan làm sâu cho đủ tương phản.
  static const light = NcPalette(
    carbon: Color(0xFFF4F6F8), // nền gốc sáng
    carbonUp: Color(0xFFFFFFFF), // card raised
    carbonPanel: Color(0xFFFFFFFF), // panel/appbar
    carbonLine: Color(0xFFDCE1E7), // hairline
    carbonLineBright: Color(0xFFC3CAD3), // border nổi
    cyan: Color(0xFF0091A7), // cyan làm sâu (đọc được trên nền trắng)
    cyanText: Color(0xFF00778A), // số liệu cyan (đậm hơn)
    cyanDim: Color(0x1A0091A7), // ~.10 nền nhấn nhẹ
    cyanGhost: Color(0x0D0091A7), // ~.05 row hover
    cyanGlow: Color(0x330091A7), // glow dịu
    white: Color(0xFF0C1114), // chữ chính (near-black)
    whiteDim: Color(0xFF566070), // chữ phụ
    green: Color(0xFF12A150),
    red: Color(0xFFE11D34),
    amber: Color(0xFFB3730A),
    mTemp: Color(0xFF0091A7),
    mHum: Color(0xFF2E6FE0),
    mGas: Color(0xFFB3730A),
    mSmoke: Color(0xFF7C4DFF),
    mFlame: Color(0xFF12A150),
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
