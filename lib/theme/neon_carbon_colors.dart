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
