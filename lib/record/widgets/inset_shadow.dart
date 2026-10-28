import 'package:flutter/material.dart';

/// Flutter 没有原生 inset box-shadow，这里用裁剪后的模糊描边模拟。
class InsetShadow extends StatelessWidget {
  const InsetShadow({
    super.key,
    required this.blur,
    required this.color,
    this.radius = 0,
  });

  final double blur;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _InsetShadowPainter(blur: blur, color: color, radius: radius),
      ),
    );
  }
}

class _InsetShadowPainter extends CustomPainter {
  const _InsetShadowPainter({
    required this.blur,
    required this.color,
    required this.radius,
  });

  final double blur;
  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || blur <= 0) return;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.save();
    canvas.clipRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = blur
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur / 2);
    canvas.drawRRect(rrect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InsetShadowPainter oldDelegate) {
    return oldDelegate.blur != blur ||
        oldDelegate.color != color ||
        oldDelegate.radius != radius;
  }
}
