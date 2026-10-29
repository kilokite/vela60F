import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'camera_feed_controller.dart';
import 'record_visuals.dart';
import 'recording_controller.dart';
import 'widgets/camera_stage.dart';
import 'widgets/control_bar.dart';

/// 记录页：上方取景，下方机械操作栏。
class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage>
    with SingleTickerProviderStateMixin {
  late final RecordingController _recording;
  late final CameraFeedController _camera;

  @override
  void initState() {
    super.initState();
    _recording = RecordingController(vsync: this);
    _camera = CameraFeedController();
    unawaited(_camera.initialize());
  }

  @override
  void dispose() {
    _recording.dispose();
    _camera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = math.min(
            constraints.maxWidth / RecordMetrics.designWidth,
            constraints.maxHeight / RecordMetrics.designHeight,
          );
          return Column(
            children: [
              Expanded(
                child: CameraStage(feed: _camera, scale: scale),
              ),
              SizedBox(
                height: RecordMetrics.barHeight * scale,
                child: ControlBar(
                  recording: _recording,
                  feed: _camera,
                  scale: scale,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
