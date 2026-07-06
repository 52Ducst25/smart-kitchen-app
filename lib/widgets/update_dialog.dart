import 'package:flutter/material.dart';

import '../models/app_update_info.dart';
import '../services/update_service.dart';
import '../theme/neon_carbon_colors.dart';
import '../theme/neon_carbon_theme.dart';
import 'glow_button.dart';

/// Popup thông báo có bản cập nhật. Hiện changelog; user bấm "Cập nhật" để tải
/// APK & bung trình cài. Nếu [AppUpdateInfo.forceUpdate] → không cho đóng.
class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key, required this.info, required this.service});

  final AppUpdateInfo info;
  final UpdateService service;

  /// Tiện ích hiện dialog (tự chặn đóng nếu là bản bắt buộc).
  static Future<void> show(
    BuildContext context,
    AppUpdateInfo info,
    UpdateService service,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: !info.forceUpdate,
      builder: (_) => UpdateDialog(info: info, service: service),
    );
  }

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _downloading = false;
  double _progress = 0;
  String? _error;

  Future<void> _startUpdate() async {
    setState(() {
      _downloading = true;
      _error = null;
      _progress = 0;
    });
    try {
      await widget.service.downloadAndInstall(
        widget.info.apkUrl,
        onProgress: (p) => setState(() => _progress = p),
      );
      // Đã bung trình cài đặt hệ thống → đóng popup, user tự bấm "Cài đặt".
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _downloading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    return PopScope(
      canPop: !info.forceUpdate && !_downloading,
      child: AlertDialog(
        backgroundColor: NcColors.carbonPanel,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: NcColors.cyan),
        ),
        title: Row(
          children: [
            const Icon(Icons.system_update, color: NcColors.cyan, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text('CÓ BẢN CẬP NHẬT', style: NcText.heading(size: 16)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phiên bản ${info.latestVersionName}',
              style: NcText.mono(size: 12),
            ),
            if (info.changelog.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(info.changelog, style: NcText.body(size: 13)),
            ],
            if (_downloading) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progress == 0 ? null : _progress,
                backgroundColor: NcColors.carbonLine,
                color: NcColors.cyan,
              ),
              const SizedBox(height: 6),
              Text(
                'Đang tải ${(_progress * 100).toStringAsFixed(0)}%',
                style: NcText.label(size: 10),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: NcText.body(size: 12, color: NcColors.red)),
            ],
          ],
        ),
        actions: _downloading
            ? null
            : [
                if (!info.forceUpdate)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'ĐỂ SAU',
                      style: NcText.label(size: 11, color: NcColors.whiteDim),
                    ),
                  ),
                GlowButton(
                  label: _error == null ? 'Cập nhật' : 'Thử lại',
                  icon: Icons.download,
                  onPressed: _startUpdate,
                ),
              ],
      ),
    );
  }
}
