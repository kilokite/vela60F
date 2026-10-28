import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// 记录状态与 10 分钟倒计时。
///
/// 现在只负责驱动仪表盘；接入真实录制后，把 start/stop 与 camera 会话绑定即可。
class RecordingController extends ChangeNotifier {
  RecordingController({required TickerProvider vsync}) {
    _ticker = vsync.createTicker(_onTick);
  }

  static const Duration maxDuration = Duration(minutes: 10);

  late final Ticker _ticker;
  final Stopwatch _stopwatch = Stopwatch();
  final ValueNotifier<bool> _recording = ValueNotifier<bool>(false);

  Duration _remaining = maxDuration;

  /// 只在开始/结束时通知，避免 60fps 重建录制键。
  ValueListenable<bool> get recordingListenable => _recording;
  bool get isRecording => _recording.value;

  Duration get remaining => _remaining;
  double get remainingMinutes =>
      _remaining.inMilliseconds / Duration.millisecondsPerMinute;

  void toggle() {
    if (isRecording) {
      stop();
    } else {
      start();
    }
  }

  void start() {
    if (isRecording) return;
    _stopwatch
      ..reset()
      ..start();
    _remaining = maxDuration;
    _recording.value = true;
    _ticker.start();
    notifyListeners();
  }

  void stop() {
    if (!isRecording) return;
    _halt();
    notifyListeners();
  }

  void _onTick(Duration _) {
    final left = maxDuration - _stopwatch.elapsed;
    if (left <= Duration.zero) {
      _halt();
      notifyListeners();
      return;
    }
    _remaining = left;
    notifyListeners();
  }

  void _halt() {
    _ticker.stop();
    _stopwatch
      ..stop()
      ..reset();
    _remaining = maxDuration;
    _recording.value = false;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _recording.dispose();
    _stopwatch.stop();
    super.dispose();
  }
}
