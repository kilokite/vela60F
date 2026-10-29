import 'package:flutter/material.dart';

/// 相机四周压暗。
///
/// 用四条边各自向内渐变，而不是模糊描边：边缘最深，向内快速淡出，
/// 这样不会出现“越靠边越浅”的平带。
class CameraVignette extends StatelessWidget {
  const CameraVignette({super.key, required this.extent, required this.color});

  /// 从边缘往内衰减的距离。
  final double extent;

  /// 边缘最深处的颜色（含 alpha）。
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _CameraVignettePainter(extent: extent, color: color),
      ),
    );
  }
}

class _CameraVignettePainter extends CustomPainter {
  const _CameraVignettePainter({required this.extent, required this.color});

  final double extent;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || extent <= 0 || color.a == 0) return;

    final edge = extent
        .clamp(0.0, size.width / 2)
        .clamp(0.0, size.height / 2)
        .toDouble();
    final colors = <Color>[
      color,
      color.withValues(alpha: color.a * 0.45),
      color.withValues(alpha: color.a * 0.12),
      color.withValues(alpha: 0),
    ];
    const stops = <double>[0, 0.3, 0.65, 1];
    final paint = Paint();

    void paintEdge(Rect rect, Alignment begin, Alignment end) {
      paint.shader = LinearGradient(
        begin: begin,
        end: end,
        colors: colors,
        stops: stops,
      ).createShader(rect);
      canvas.drawRect(rect, paint);
    }

    paintEdge(
      Rect.fromLTWH(0, 0, size.width, edge),
      Alignment.topCenter,
      Alignment.bottomCenter,
    );
    paintEdge(
      Rect.fromLTWH(0, size.height - edge, size.width, edge),
      Alignment.bottomCenter,
      Alignment.topCenter,
    );
    paintEdge(
      Rect.fromLTWH(0, 0, edge, size.height),
      Alignment.centerLeft,
      Alignment.centerRight,
    );
    paintEdge(
      Rect.fromLTWH(size.width - edge, 0, edge, size.height),
      Alignment.centerRight,
      Alignment.centerLeft,
    );
  }

  @override
  bool shouldRepaint(covariant _CameraVignettePainter oldDelegate) {
    return oldDelegate.extent != extent || oldDelegate.color != color;
  }
}
