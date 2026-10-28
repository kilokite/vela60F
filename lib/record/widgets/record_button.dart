import 'package:flutter/material.dart';

import '../record_visuals.dart';

/// 待机时是一枚白色圆钮；录制中变成红方块 + 白色圆环。
class RecordButton extends StatelessWidget {
  const RecordButton({
    super.key,
    required this.isRecording,
    required this.scale,
  });

  final bool isRecording;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: RecordMetrics.keyWidth * scale,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.82, end: 1).animate(animation),
                child: child,
              ),
            );
          },
          child: isRecording
              ? _StopMark(key: const ValueKey('recording'), scale: scale)
              : _IdleMark(key: const ValueKey('idle'), scale: scale),
        ),
      ),
    );
  }
}

class _IdleMark extends StatelessWidget {
  const _IdleMark({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40 * scale,
      height: 40 * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF1F1F1)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            offset: Offset(0, 1 * scale),
            blurRadius: 2 * scale,
          ),
        ],
      ),
    );
  }
}

class _StopMark extends StatelessWidget {
  const _StopMark({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 56 * scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 56 * scale,
            height: 56 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  offset: Offset(0, 1 * scale),
                  blurRadius: 2 * scale,
                ),
              ],
            ),
          ),
          Container(
            width: 24 * scale,
            height: 24 * scale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6 * scale),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [RecordColors.record, RecordColors.recordDeep],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  offset: Offset(0, 1 * scale),
                  blurRadius: 2 * scale,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
