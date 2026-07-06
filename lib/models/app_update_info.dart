/// Model metadata cập nhật OTA — đọc từ file `update.json` (raw) trên GitHub.
///
/// Schema: xem `plans/260706-0843-ota-in-app-update/phase-02-update-metadata-and-hosting.md`.
/// Các trường số parse an toàn (chấp nhận int/num/string) để tránh crash khi
/// dữ liệu nhập tay trên GitHub bị lệch kiểu.
class AppUpdateInfo {
  const AppUpdateInfo({
    required this.latestVersionCode,
    required this.latestVersionName,
    required this.apkUrl,
    required this.changelog,
    required this.minSupportedVersionCode,
    required this.currentVersionCode,
  });

  final int latestVersionCode;
  final String latestVersionName;
  final String apkUrl;
  final String changelog;
  final int minSupportedVersionCode;

  /// versionCode của app đang chạy — điền lúc check (không nằm trong JSON).
  final int currentVersionCode;

  /// Có bản mới hơn bản đang cài.
  bool get updateAvailable => latestVersionCode > currentVersionCode;

  /// Bản đang cài quá cũ (< ngưỡng tối thiểu) → buộc cập nhật, không cho bỏ qua.
  bool get forceUpdate => currentVersionCode < minSupportedVersionCode;

  factory AppUpdateInfo.fromJson(
    Map<String, dynamic> json, {
    required int currentVersionCode,
  }) {
    return AppUpdateInfo(
      latestVersionCode: _asInt(json['latestVersionCode']),
      latestVersionName: (json['latestVersionName'] ?? '').toString(),
      apkUrl: (json['apkUrl'] ?? '').toString(),
      changelog: (json['changelog'] ?? '').toString(),
      minSupportedVersionCode: _asInt(json['minSupportedVersionCode']),
      currentVersionCode: currentVersionCode,
    );
  }

  static int _asInt(Object? v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
