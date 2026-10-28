import 'package:flutter/material.dart';

import '../camera_feed_controller.dart';
import '../record_visuals.dart';
import '../recording_controller.dart';
import 'album_window.dart';
import 'dial_gauge.dart';
import 'key_icons.dart';
import 'physical_key.dart';
import 'record_button.dart';

/// 底部 90pt 操作栏：鼓轮 + 翻转 + 拍照 + 相册窗 + 录制键。
class ControlBar extends StatelessWidget {
  const ControlBar({
    super.key,
    required this.recording,
    required this.feed,
    required this.scale,
  });

  final RecordingController recording;
  final CameraFeedController feed;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final height = RecordMetrics.barHeight * scale;
    final keyWidth = RecordMetrics.keyWidth * scale;
    final flipWidth = RecordMetrics.flipKeyWidth * scale;
    final iconSize = 28 * scale;

    return SizedBox(
      height: height,
      child: ColoredBox(
        color: RecordColors.bar,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: DialGauge(recording: recording, scale: scale),
            ),
            PhysicalKey(
              width: flipWidth,
              height: height,
              semanticLabel: '翻转摄像头',
              onTap: feed.flip,
              child: FlipCameraIcon(size: iconSize),
            ),
            PhysicalKey(
              width: keyWidth,
              height: height,
              semanticLabel: '拍照',
              onTap: _noop,
              child: CaptureIcon(size: iconSize),
            ),
            PhysicalKey(
              width: keyWidth,
              height: height,
              flat: true,
              semanticLabel: '相册',
              onTap: _noop,
              child: AlbumWindow(size: RecordMetrics.albumSize * scale),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: recording.recordingListenable,
              builder: (context, isRecording, _) {
                return PhysicalKey(
                  width: keyWidth,
                  height: height,
                  semanticLabel: isRecording ? '停止录制' : '开始录制',
                  onTap: recording.toggle,
                  child: RecordButton(isRecording: isRecording, scale: scale),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _noop() {}
