import 'package:flutter/material.dart';

import '../record_visuals.dart';
import 'inset_shadow.dart';

/// 相册观察窗。现在放的是设计稿里的占位缩略图，接相册后换成最近一条记录。
class AlbumWindow extends StatelessWidget {
  const AlbumWindow({super.key, required this.size});

  final double size;

  static const String _placeholder = 'assets/images/album_placeholder.jpg';

  @override
  Widget build(BuildContext context) {
    final scale = size / RecordMetrics.albumSize;
    final radius = RecordMetrics.albumRadius * scale;
    final borderRadius = BorderRadius.circular(radius);

    return SizedBox.square(
      dimension: size,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              _placeholder,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              excludeFromSemantics: true,
            ),
            Positioned.fill(
              child: InsetShadow(
                // Figma 标的是 23.1，但按 CSS 内阴影渲染后过重；
                // 收到 18 并将不透明度降到 55%，以贴近设计稿的实际观感。
                blur: 18 * scale,
                color: Colors.black.withValues(alpha: 0.55),
                radius: radius,
              ),
            ),
            Positioned(
              left: 9 * scale,
              right: 9 * scale,
              bottom: 0.5 * scale,
              height: 1 * scale,
              child: const ColoredBox(color: Color(0x1AFFFFFF)),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: const Color(0x59000000),
                    width: 1 * scale,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
