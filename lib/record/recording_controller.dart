import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// 记录状态与 10 分钟倒计时。
///
/// 计时由 Ticker 的 elapsed 驱动；停止后鼓轮会用缓出曲线倒带回 10:00，
/// 而不是瞬跳。接入真实录制后，把 start/stop 与 camera 会话绑定即可。
class RecordingController extends ChangeNotifier {
  RecordingController({required TickerProvider vsync}) {
    _ticker = vsync.createTicker(_onTick);
  }

  static const Duration maxDuration = Duration(minutes: 10);
  static const Curve _rewindCurve = Curves.easeOutQuart;

  late final Ticker _ticker;
  final ValueNotifier<bool> _recording = ValueNotifier<bool>(false);

  _Motion _motion = _Motion.idle;
  Duration _remaining = maxDuration;
  Duration _rewindFrom = maxDuration;
  Duration _rewindDuration = Duration.zero;

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
    _ticker.stop();
    _motion = _Motion.recording;
    _remaining = maxDuration;
    _recording.value = true;
    _ticker.start();
    notifyListeners();
  }

  void stop() {
    if (!isRecording) return;
    _recording.value = false;
    _startRewind(_remaining);
  }

  void _onTick(Duration elapsed) {
    switch (_motion) {
      case _Motion.recording:
        final left = maxDuration - elapsed;
        if (left <= Duration.zero) {
          _recording.value = false;
          _startRewind(Duration.zero);
          return;
        }
        _remaining = left;
        notifyListeners();
        break;
      case _Motion.rewinding:
        final total = _rewindDuration.inMicroseconds;
        final t = total <= 0
            ? 1.0
            : (elapsed.inMicroseconds / total).clamp(0.0, 1.0).toDouble();
        final eased = _rewindCurve.transform(t);
        final from = _rewindFrom.inMicroseconds;
        final to = maxDuration.inMicroseconds;
        _remaining = Duration(
          microseconds: (from + (to - from) * eased).round(),
        );
        if (t >= 1) {
          _finishRewind();
        } else {
          notifyListeners();
        }
        break;
      case _Motion.idle:
        break;
    }
  }

  void _startRewind(Duration from) {
    _ticker.stop();
    _motion = _Motion.rewinding;
    _rewindFrom = from;
    _remaining = from;

    final distance = maxDuration - from;
    if (distance <= Duration.zero) {
      _finishRewind();
      return;
    }

    final fraction = distance.inMicroseconds / maxDuration.inMicroseconds;
    final ms = (280 + 900 * fraction).round().clamp(400, 1200).toInt();
    _rewindDuration = Duration(milliseconds: ms);
    _ticker.start();
    notifyListeners();
  }

  void _finishRewind() {
    _ticker.stop();
    _motion = _Motion.idle;
    _remaining = maxDuration;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _recording.dispose();
    super.dispose();
  }
}

enum _Motion { idle, recording, rewinding }
