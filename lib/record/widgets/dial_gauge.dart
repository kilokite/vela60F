import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../recording_controller.dart';
import '../record_visuals.dart';

/// 机械仪表盘式的 10 分钟倒计时鼓轮。
///
/// 鼓轮按圆柱面投影，值向左/右滚动；中心基准红线固定不动。
class DialGauge extends StatelessWidget {
  const DialGauge({super.key, required this.recording, required this.scale});

  final RecordingController recording;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: RecordColors.dialFace),
          RepaintBoundary(
            child: ListenableBuilder(
              listenable: recording,
              builder: (context, _) {
                return CustomPaint(
                  painter: _DialDrumPainter(
                    remainingMinutes: recording.remainingMinutes,
                    scale: scale,
                  ),
                );
              },
            ),
          ),
          CustomPaint(painter: _DialGlassPainter(scale: scale)),
        ],
      ),
    );
  }
}

class _DialDrumPainter extends CustomPainter {
  _DialDrumPainter({required this.remainingMinutes, required this.scale});

  final double remainingMinutes;
  final double scale;

  double _x(double minute, double center, double amplitude) {
    return center +
        amplitude *
            math.sin((minute - remainingMinutes) / RecordMetrics.dialCurve);
  }

  double _angle(double minute) {
    return (minute - remainingMinutes) / RecordMetrics.dialCurve;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width / 2;
    final amplitude = RecordMetrics.dialAmplitude * scale;

    // 最后一分钟（0:00–1:00）的红色端区。
    // 鼓轮投影是周期函数，必须用可见角度裁掉回绕到另一侧的区间。
    final xEnd = _x(0, center, amplitude);
    final xOne = _x(1, center, amplitude);
    final angleEnd = _angle(0);
    final angleOne = _angle(1);
    final endZoneVisible = angleEnd.abs() <= 1.34 || angleOne.abs() <= 1.34;
    if (endZoneVisible && xEnd < xOne && xEnd < size.width && xOne > 0) {
      canvas.drawRect(
        Rect.fromLTRB(xEnd, 0, xOne, size.height),
        Paint()..color = RecordColors.accent.withValues(alpha: 0.06),
      );
    }

    final tickPaint = Paint();
    for (var i = 0; i <= 125; i++) {
      final minute = i / 10;
      final angle = _angle(minute);
      if (angle.abs() > 1.34) continue;

      final x = center + amplitude * math.sin(angle);
      if (x < -4 || x > size.width + 4) continue;

      final isMinute = i % 10 == 0;
      final isHalfMinute = i % 5 == 0;
      final distance = (minute - remainingMinutes).abs();
      final cosine = math.cos(angle).clamp(0.0, 1.0).toDouble();

      final double height;
      final double baseWidth;
      final double widthFactor;
      double opacity;
      if (isMinute) {
        height = 34;
        baseWidth = 1.8;
        widthFactor = 0.6 + 0.4 * cosine;
        opacity = (1.0 - 0.095 * distance).clamp(0.78, 1.0);
      } else if (isHalfMinute) {
        height = 22;
        baseWidth = 1.29;
        widthFactor = 0.83 + 0.17 * cosine;
        opacity = distance <= 0.5
            ? 0.77
            : (0.77 -
                      0.2 *
                          math.pow(
                            ((distance - 0.5) / 2.0).clamp(0.0, 1.0),
                            1.5,
                          ))
                  .clamp(0.57, 0.77);
      } else {
        height = 13;
        baseWidth = 0.9;
        widthFactor = 0.83 + 0.17 * cosine;
        opacity = distance <= 1.0
            ? 0.52
            : (0.52 - 0.087 * (distance - 1.0)).clamp(0.39, 0.52);
      }

      final color = minute < 1.0
          ? RecordColors.accent
          : (isMinute ? RecordColors.tickStrong : RecordColors.tick);
      tickPaint.color = color.withValues(alpha: opacity.toDouble());
      final width = baseWidth * scale * widthFactor;
      canvas.drawRect(
        Rect.fromLTWH(
          x - width / 2,
          size.height - height * scale,
          width,
          height * scale,
        ),
        tickPaint,
      );
    }

    final labelStyle = TextStyle(
      fontSize: 27 * scale,
      fontWeight: FontWeight.w600,
      height: 1.22,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    for (var minute = 0; minute <= 10; minute++) {
      final angle = _angle(minute.toDouble());
      if (angle.abs() > 1.16) continue;
      final x = center + amplitude * math.sin(angle);
      if (x < -24 || x > size.width + 24) continue;

      final painter = TextPainter(
        text: TextSpan(
          text: '$minute',
          style: labelStyle.copyWith(
            color: minute == 0 ? RecordColors.accent : RecordColors.ink,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(x - painter.width / 2, 10 * scale));
      painter.dispose();
    }
  }

  @override
  bool shouldRepaint(covariant _DialDrumPainter oldDelegate) {
    return oldDelegate.remainingMinutes != remainingMinutes ||
        oldDelegate.scale != scale;
  }
}

/// 鼓轮表面的固定光学层：曲率明暗、上槽口、基准红线、内阴影。
class _DialGlassPainter extends CustomPainter {
  const _DialGlassPainter({required this.scale});

  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(58, 58, 58, 0.58),
            Color.fromRGBO(74, 74, 74, 0.42),
            Color.fromRGBO(106, 106, 106, 0.22),
            Color.fromRGBO(144, 144, 144, 0.1),
            Color.fromRGBO(176, 176, 176, 0.02),
            Color.fromRGBO(192, 192, 192, 0),
            Color.fromRGBO(192, 192, 192, 0),
            Color.fromRGBO(176, 176, 176, 0.02),
            Color.fromRGBO(144, 144, 144, 0.1),
            Color.fromRGBO(106, 106, 106, 0.22),
            Color.fromRGBO(74, 74, 74, 0.42),
            Color.fromRGBO(58, 58, 58, 0.58),
          ],
          stops: [
            0,
            0.025,
            0.06,
            0.10,
            0.17,
            0.28,
            0.72,
            0.83,
            0.90,
            0.94,
            0.975,
            1,
          ],
        ).createShader(rect),
    );

    final slot = Rect.fromLTWH(0, 0, size.width, 7 * scale);
    canvas.drawRect(
      slot,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(0, 0, 0, 0.2),
            Color.fromRGBO(0, 0, 0, 0.06),
            Color.fromRGBO(0, 0, 0, 0),
          ],
          stops: [0, 0.55, 1],
        ).createShader(slot),
    );

    final lineWidth = 1.8 * scale;
    final lineLeft = size.width / 2 - lineWidth / 2;
    canvas.drawRect(
      Rect.fromLTWH(lineLeft + 1 * scale, 0, lineWidth, size.height),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.16)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5 * scale),
    );
    canvas.drawRect(
      Rect.fromLTWH(lineLeft, 0, lineWidth, size.height),
      Paint()..color = RecordColors.accent.withValues(alpha: 0.6),
    );

    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = RecordMetrics.dialInset * 2 * scale
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          RecordMetrics.dialInset * scale,
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _DialGlassPainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}
