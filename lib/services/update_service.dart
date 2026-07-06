import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/app_update_info.dart';

// ============================================================================
// CẤU HÌNH NGUỒN CẬP NHẬT — sửa 3 hằng dưới sau khi tạo repo GitHub riêng.
// URL raw: https://raw.githubusercontent.com/<owner>/<repo>/<branch>/update.json
// ============================================================================
const _owner = '52Ducst25'; // owner GitHub
const _repo = 'smart-kitchen-app'; // repo riêng cho app-flutter
const _branch = 'main'; // nhánh chứa update.json

String get _updateJsonUrl =>
    'https://raw.githubusercontent.com/$_owner/$_repo/$_branch/update.json';

/// Dịch vụ cập nhật OTA (Android): đọc `update.json` qua HTTP, so versionCode;
/// nếu có bản mới → UI gọi [downloadAndInstall] tải APK từ GitHub Releases và
/// bung trình cài đặt hệ thống. KHÔNG dùng Firebase.
class UpdateService {
  UpdateService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  /// Đọc metadata + so version. Trả `null` nếu lỗi (offline/JSON sai) hoặc đã
  /// là bản mới nhất → luồng khởi động im lặng, không quấy user.
  Future<AppUpdateInfo?> check() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentCode = int.tryParse(info.buildNumber) ?? 0;

      // Chống cache CDN của raw.githubusercontent (~5 phút).
      final cacheBust = DateTime.now().millisecondsSinceEpoch;
      final res = await _dio.get<dynamic>(
        '$_updateJsonUrl?t=$cacheBust',
        options: Options(responseType: ResponseType.json),
      );

      final data = res.data;
      if (data is! Map) return null;
      final map = data.map((k, v) => MapEntry(k.toString(), v));

      final update = AppUpdateInfo.fromJson(
        Map<String, dynamic>.from(map),
        currentVersionCode: currentCode,
      );
      return update.updateAvailable ? update : null;
    } catch (_) {
      return null;
    }
  }

  /// Tải APK về thư mục tạm rồi bung trình cài đặt.
  /// [onProgress] nhận 0..1. Ném lỗi nếu link sai / thiếu quyền / tải hỏng.
  Future<void> downloadAndInstall(
    String apkUrl, {
    void Function(double progress)? onProgress,
  }) async {
    if (!apkUrl.startsWith('https://')) {
      throw const FormatException('Link APK không hợp lệ (phải là https).');
    }

    // Android 8+: cần quyền cài app từ nguồn ngoài Play Store.
    final status = await Permission.requestInstallPackages.request();
    if (!status.isGranted) {
      throw Exception(
        'Cần cấp quyền "Cài ứng dụng không xác định" để cập nhật.',
      );
    }

    final dir = await getTemporaryDirectory();
    final savePath = '${dir.path}/smart-kitchen-update.apk';

    await _dio.download(
      apkUrl,
      savePath,
      onReceiveProgress: (received, total) {
        if (total > 0) onProgress?.call(received / total);
      },
    );

    final result = await OpenFilex.open(savePath);
    if (result.type != ResultType.done) {
      throw Exception('Không mở được trình cài đặt: ${result.message}');
    }
  }
}
