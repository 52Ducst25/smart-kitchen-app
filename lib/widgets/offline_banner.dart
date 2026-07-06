import 'package:flutter/material.dart';

import '../theme/neon_carbon_colors.dart';
import '../theme/neon_carbon_theme.dart';

/// Banner cảnh báo thiết bị mất kết nối — dữ liệu hiển thị có thể đã cũ.
/// Hiện khi >15s không nhận được dữ liệu cảm biến (xem AppState.isDeviceOffline).
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final nc = context.nc;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: nc.amber.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: nc.amber.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_outlined, color: nc.amber, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Thiết bị mất kết nối — số liệu có thể đã cũ.',
              style: NcText.body(size: 12.5, color: nc.amber),
            ),
          ),
        ],
      ),
    );
  }
}
