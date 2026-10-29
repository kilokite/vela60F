import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../record_visuals.dart';

/// 操作栏里的一块“塑料键”。
///
/// 负责键面渐变、上下高光/暗部、键缝和按压反馈；flat 用于相册窗所在的凹槽。
class PhysicalKey extends StatefulWidget {
  const PhysicalKey({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.flat = false,
    this.seam = true,
  });

  final double width;
  final double height;
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool flat;
  final bool seam;

  @override
  State<PhysicalKey> createState() => _PhysicalKeyState();
}

class _PhysicalKeyState extends State<PhysicalKey> {
  bool _pressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap == null) return;
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (!_pressed) return;
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    if (!_pressed) return;
    setState(() => _pressed = false);
  }

  void _handleTap() {
    if (widget.onTap == null) return;
    HapticFeedback.selectionClick();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.height / RecordMetrics.barHeight;
    return Semantics(
      button: widget.onTap != null,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.onTap == null ? null : _handleTapDown,
        onTapUp: widget.onTap == null ? null : _handleTapUp,
        onTapCancel: widget.onTap == null ? null : _handleTapCancel,
        onTap: widget.onTap == null ? null : _handleTap,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.flat)
                const ColoredBox(color: RecordColors.bar)
              else
                _KeySurface(scale: scale),
              Center(child: widget.child),
              if (_pressed) const ColoredBox(color: Color(0x0AFFFFFF)),
              if (widget.seam) _KeySeam(scale: scale),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeySurface extends StatelessWidget {
  const _KeySurface({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                RecordColors.keyTop,
                RecordColors.keyUpper,
                RecordColors.keyLower,
                RecordColors.keyBottom,
              ],
              stops: [0, 0.2, 0.62, 1],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 1 * scale,
          child: const ColoredBox(color: Color(0x0DFFFFFF)),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 1 * scale,
          height: 1 * scale,
          child: const ColoredBox(color: Color(0x04FFFFFF)),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 6 * scale,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00000000),
                  Color(0x0D000000),
                  Color(0x1C000000),
                  Color(0x2B000000),
                ],
                stops: [0, 0.4, 0.8, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _KeySeam extends StatelessWidget {
  const _KeySeam({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 1 * scale,
          child: const ColoredBox(color: Color(0x9E000000)),
        ),
        Positioned(
          left: 1 * scale,
          top: 0,
          bottom: 0,
          width: 1 * scale,
          child: const ColoredBox(color: Color(0x0DFFFFFF)),
        ),
      ],
    );
  }
}
