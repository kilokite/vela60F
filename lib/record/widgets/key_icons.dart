import 'package:flutter/material.dart';

import '../record_visuals.dart';

/// 28 × 28 的翻转摄像头图标（从 Figma 矢量图还原）。
class FlipCameraIcon extends StatelessWidget {
  const FlipCameraIcon({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _FlipCameraPainter(),
    );
  }
}

class _FlipCameraPainter extends CustomPainter {
  const _FlipCameraPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 28);
    final paint = Paint()
      ..color = RecordColors.icon
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.98333
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(4.2, 10.6167)
      ..lineTo(18.4333, 10.6167)
      ..moveTo(15.5167, 7.35)
      ..lineTo(19.1333, 10.6167)
      ..lineTo(15.5167, 13.8833)
      ..moveTo(23.8, 17.3833)
      ..lineTo(9.56667, 17.3833)
      ..moveTo(12.4833, 14.1167)
      ..lineTo(8.86667, 17.3833)
      ..lineTo(12.4833, 20.65);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FlipCameraPainter oldDelegate) => false;
}

/// 28 × 28 的拍照图标（从 Figma 矢量图还原）。
class CaptureIcon extends StatelessWidget {
  const CaptureIcon({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _CapturePainter(),
    );
  }
}

class _CapturePainter extends CustomPainter {
  const _CapturePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 28);
    final paint = Paint()
      ..color = RecordColors.icon
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.98333
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final body = Path()
      ..moveTo(10.7333, 7.58333)
      ..lineTo(12.1333, 5.36667)
      ..lineTo(15.8667, 5.36667)
      ..lineTo(17.2667, 7.58333)
      ..lineTo(21.1167, 7.58333)
      ..quadraticBezierTo(22.9833, 7.58333, 22.9833, 9.45)
      ..lineTo(22.9833, 19.25)
      ..quadraticBezierTo(22.9833, 21.1167, 21.1167, 21.1167)
      ..lineTo(6.88333, 21.1167)
      ..quadraticBezierTo(5.01667, 21.1167, 5.01667, 19.25)
      ..lineTo(5.01667, 9.45)
      ..quadraticBezierTo(5.01667, 7.58333, 6.88333, 7.58333)
      ..close();
    canvas.drawPath(body, paint);
    canvas.drawCircle(const Offset(14, 15.1667), 3.9667, paint);
  }

  @override
  bool shouldRepaint(covariant _CapturePainter oldDelegate) => false;
}
