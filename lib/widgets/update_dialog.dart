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

class _UpdateDialogState extends State<UpdateDialog> with WidgetsBindingObserver {
  bool _downloading = false;
  bool _awaitingPerm = false; // đã mở Settings xin quyền, chờ user bật & quay lại
  double _progress = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Sau khi user bật quyền trong Settings và quay lại app → TỰ tiếp tục tải &
    // cài, không bắt bấm "Cập nhật" lần 2 (đây là lý do trước phải bấm 2 lần).
    if (state == AppLifecycleState.resumed && _awaitingPerm) {
      widget.service.hasInstallPermission().then((granted) {
        if (granted && mounted) {
          _awaitingPerm = false;
          _download();
        }
      });
    }
  }

  Future<void> _startUpdate() async {
    setState(() => _error = null);
    final granted = await widget.service.ensureInstallPermission();
    if (!granted) {
      // Đã mở Settings xin quyền → chờ user bật rồi quay lại (app tự tiếp tục).
      setState(() {
        _awaitingPerm = true;
        _downloading = false;
        _error = 'Hãy bật quyền "Cài ứng dụng không xác định" rồi quay lại — '
            'app sẽ tự tải & cài, không cần bấm lại.';
      });
      return;
    }
    await _download();
  }

  Future<void> _download() async {
    setState(() {
      _downloading = true;
      _awaitingPerm = false;
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
    final nc = context.nc;
    return PopScope(
      canPop: !info.forceUpdate && !_downloading,
      child: AlertDialog(
        backgroundColor: nc.carbonPanel,
        shape: RoundedRectangleBorder(side: BorderSide(color: nc.cyan)),
        title: Row(
          children: [
            Icon(Icons.system_update, color: nc.cyan, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'CÓ BẢN CẬP NHẬT',
                style: NcText.heading(size: 16, color: nc.white),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phiên bản ${info.latestVersionName}',
              style: NcText.mono(size: 12, color: nc.cyanText),
            ),
            if (info.changelog.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(info.changelog, style: NcText.body(size: 13, color: nc.whiteDim)),
            ],
            if (_downloading) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progress == 0 ? null : _progress,
                backgroundColor: nc.carbonLine,
                color: nc.cyan,
              ),
              const SizedBox(height: 6),
              Text(
                'Đang tải ${(_progress * 100).toStringAsFixed(0)}%',
                style: NcText.label(size: 10, color: nc.whiteDim),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: NcText.body(size: 12, color: nc.red)),
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
                      style: NcText.label(size: 11, color: nc.whiteDim),
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
