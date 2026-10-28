import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../camera_feed_controller.dart';
import '../record_visuals.dart';
import 'camera_vignette.dart';

/// 摄像头取景区域，带设计稿里的四周压暗。
class CameraStage extends StatelessWidget {
  const CameraStage({super.key, required this.feed, required this.scale});

  final CameraFeedController feed;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: ListenableBuilder(
        listenable: feed,
        builder: (context, _) {
          final controller = feed.camera;
          final ready =
              controller != null &&
              controller.value.isInitialized &&
              !feed.isOpening;
          return Stack(
            fit: StackFit.expand,
            children: [
              const _StageBackdrop(),
              if (ready) _CameraPreview(controller: controller),
              if (!ready && feed.isUnavailable)
                Center(
                  child: Icon(
                    Icons.videocam_off_outlined,
                    size: 56 * scale,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              Positioned.fill(
                child: CameraVignette(
                  extent: RecordMetrics.stageVignette * scale,
                  color: Colors.black.withValues(alpha: 0.45),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StageBackdrop extends StatelessWidget {
  const _StageBackdrop();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1.2,
          colors: [Color(0xFF171717), Color(0xFF0A0A0A)],
        ),
      ),
    );
  }
}

class _CameraPreview extends StatelessWidget {
  const _CameraPreview({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final aspect = controller.value.aspectRatio;
    if (aspect <= 0 || !aspect.isFinite) {
      return const SizedBox.shrink();
    }
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: 1000,
        height: 1000 / aspect,
        child: CameraPreview(controller),
      ),
    );
  }
}
