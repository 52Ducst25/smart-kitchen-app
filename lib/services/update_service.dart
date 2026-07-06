import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/app_update_info.dart';

// ============================================================================
// CẤU HÌNH NGUỒN CẬP NHẬT — sửa 3 hằng dưới sau khi tạo repo GitHub riêng.
// Đọc update.json qua GitHub Contents API (media type raw) thay vì
// raw.githubusercontent.com: raw có cache CDN 5 phút và BỎ QUA query chống cache
// (?t=) → cập nhật bị trễ tới 5 phút sau mỗi release. API trả nội dung mới gần
// như tức thì (giới hạn ~60 lần/giờ/IP, đủ cho app kiểm tra lúc mở/bấm nút).
// ============================================================================
const _owner = '52Ducst25'; // owner GitHub
const _repo = 'smart-kitchen-app'; // repo riêng cho app-flutter
const _branch = 'main'; // nhánh chứa update.json

String get _updateJsonUrl =>
    'https://api.github.com/repos/$_owner/$_repo/contents/update.json?ref=$_branch';

/// Dịch vụ cập nhật OTA (Android): đọc `update.json` qua HTTP, so versionCode;
/// nếu có bản mới → UI gọi [downloadAndInstall] tải APK từ GitHub Releases và
/// bung trình cài đặt hệ thống. KHÔNG dùng Firebase.
class UpdateService {
  UpdateService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  /// Đọc metadata + so version. Trả `null` khi ĐÃ là bản mới nhất.
  /// NÉM lỗi nếu offline / URL sai / JSON hỏng — để nút "Kiểm tra cập nhật"
  /// thủ công hiển thị được lý do; luồng khởi động sẽ tự bắt & im lặng.
  Future<AppUpdateInfo?> check() async {
    final info = await PackageInfo.fromPlatform();
    final currentCode = int.tryParse(info.buildNumber) ?? 0;

    // Contents API + Accept "raw" → trả thẳng nội dung file, mới gần như tức thì.
    // Ép nhận CHUỖI thô rồi tự jsonDecode (không phụ thuộc content-type trả về).
    // GitHub API bắt buộc có User-Agent, nếu thiếu sẽ trả 403.
    final res = await _dio.get<String>(
      _updateJsonUrl,
      options: Options(
        responseType: ResponseType.plain,
        headers: const {
          'Accept': 'application/vnd.github.raw',
          'User-Agent': 'SmartKitchenApp',
        },
      ),
    );

    final decoded = jsonDecode(res.data ?? '');
    if (decoded is! Map) {
      throw const FormatException('update.json không đúng định dạng.');
    }
    final map = decoded.map((k, v) => MapEntry(k.toString(), v));

    final update = AppUpdateInfo.fromJson(
      Map<String, dynamic>.from(map),
      currentVersionCode: currentCode,
    );
    return update.updateAvailable ? update : null;
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
