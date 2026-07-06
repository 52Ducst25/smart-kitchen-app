// Chuyển ảnh logo (JPG) sang PNG vuông cho icon app.
// Chạy: dart run tool/convert_icon.dart <nguồn> <đích>
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as img;

void main(List<String> args) {
  final srcPath = args.isNotEmpty
      ? args[0]
      : r'C:/Users/Admin/Downloads/logo.jpg';
  final dstPath = args.length > 1 ? args[1] : 'assets/icon/app_icon.png';

  final decoded = img.decodeImage(File(srcPath).readAsBytesSync());
  if (decoded == null) {
    stderr.writeln('Không đọc được ảnh: $srcPath');
    exit(1);
  }

  // Cắt vuông (lấy cạnh nhỏ nhất, canh giữa) rồi xuất PNG.
  final side = decoded.width < decoded.height ? decoded.width : decoded.height;
  final x = ((decoded.width - side) / 2).round();
  final y = ((decoded.height - side) / 2).round();
  final square = img.copyCrop(decoded, x: x, y: y, width: side, height: side);

  File(dstPath).writeAsBytesSync(img.encodePng(square));
  stdout.writeln('OK: ${square.width}x${square.height} -> $dstPath');
}
