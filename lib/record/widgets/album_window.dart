import 'package:flutter/material.dart';

import '../record_visuals.dart';
import 'inner_shadow.dart';

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
            Positioned.fill(
              child: InnerShadow(
                // 设计稿是 inset 0 0 23.1px；ImageFilter 的 sigma 取一半。
                blur: 11.5 * scale,
                color: Colors.black,
                offset: Offset.zero,
                child: Image.asset(
                  _placeholder,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  excludeFromSemantics: true,
                ),
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
