import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 基于 RenderProxyBox 的内阴影。
///
/// 思路：把子节点画进一层，再用 `srcOut` 取“模糊后的子节点 alpha 之外”的区域
/// 作为阴影色，最后用 `srcATop` 把它限制在子节点内部。
///
/// `offset` 为 [Offset.zero] 时是四周均匀内阴影；非零时阴影偏向一侧。
class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    super.key,
    this.blur = 10,
    this.color = Colors.black38,
    this.offset = const Offset(10, 10),
    super.child,
  });

  /// 高斯模糊的 sigma 值，越大阴影扩散越深。
  final double blur;
  final Color color;

  /// 阴影偏移；[Offset.zero] 为均匀内阴影。
  final Offset offset;

  @override
  RenderInnerShadow createRenderObject(BuildContext context) {
    return RenderInnerShadow()
      ..blur = blur
      ..color = color
      ..shadowOffset = offset;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderInnerShadow renderObject,
  ) {
    renderObject
      ..blur = blur
      ..color = color
      ..shadowOffset = offset;
  }
}

class RenderInnerShadow extends RenderProxyBox {
  double _blur = 10;
  Color _color = Colors.black38;
  Offset _shadowOffset = const Offset(10, 10);

  double get blur => _blur;
  set blur(double value) {
    if (_blur == value) return;
    _blur = value;
    markNeedsPaint();
  }

  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  Offset get shadowOffset => _shadowOffset;
  set shadowOffset(Offset value) {
    if (_shadowOffset == value) return;
    _shadowOffset = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child == null) return;

    final rectOuter = offset & size;
    final rectInner = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width - _shadowOffset.dx,
      size.height - _shadowOffset.dy,
    );

    final canvas = context.canvas..saveLayer(rectOuter, Paint());
    context.paintChild(child, offset);

    final shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: _blur, sigmaY: _blur)
      ..colorFilter = ColorFilter.mode(_color, BlendMode.srcOut);

    canvas
      ..saveLayer(rectOuter, shadowPaint)
      ..saveLayer(rectInner, Paint())
      ..translate(_shadowOffset.dx, _shadowOffset.dy);
    context.paintChild(child, offset);
    canvas
      ..restore()
      ..restore()
      ..restore();
  }
}
