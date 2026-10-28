import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

/// camera 会话的薄封装：初始化、前后摄像头切换、生命周期回收。
///
/// 当前只开预览（enableAudio: false），不录制、不拍照。
class CameraFeedController extends ChangeNotifier with WidgetsBindingObserver {
  CameraFeedController() {
    WidgetsBinding.instance.addObserver(this);
  }

  List<CameraDescription> _cameras = const [];
  CameraController? _camera;
  int _index = 0;
  bool _opening = true;
  bool _unavailable = false;
  bool _disposed = false;

  CameraController? get camera => _camera;
  bool get isOpening => _opening;
  bool get isUnavailable => _unavailable;

  bool get canFlip {
    if (_cameras.isEmpty) return false;
    final direction = _cameras[_index].lensDirection;
    return _cameras.any((camera) => camera.lensDirection != direction);
  }

  Future<void> initialize() async {
    if (_disposed) return;
    _opening = true;
    _unavailable = false;
    _notify();
    try {
      final cameras = await availableCameras();
      if (_disposed) return;
      _cameras = cameras;
      if (cameras.isEmpty) {
        _unavailable = true;
        return;
      }
      _index = _defaultIndex(cameras);
      await _openAt(_index);
    } on CameraException {
      _unavailable = true;
    } catch (_) {
      _unavailable = true;
    } finally {
      _opening = false;
      _notify();
    }
  }

  Future<void> flip() async {
    if (_opening || !canFlip) return;
    final current = _cameras[_index].lensDirection;
    final target = current == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;
    final targetIndex = _cameras.indexWhere(
      (camera) => camera.lensDirection == target,
    );
    if (targetIndex < 0) return;
    await _switchTo(targetIndex);
  }

  Future<void> _switchTo(int index) async {
    _opening = true;
    _notify();
    try {
      await _openAt(index);
      _index = index;
      _unavailable = false;
    } catch (_) {
      _unavailable = _camera == null;
    } finally {
      _opening = false;
      _notify();
    }
  }

  Future<void> _openAt(int index) async {
    final previous = _camera;
    _camera = null;
    if (previous != null) {
      await previous.dispose();
    }
    final next = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await next.initialize();
    } catch (_) {
      await next.dispose();
      rethrow;
    }
    if (_disposed) {
      await next.dispose();
      return;
    }
    _camera = next;
  }

  int _defaultIndex(List<CameraDescription> cameras) {
    final back = cameras.indexWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );
    return back >= 0 ? back : 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      final current = _camera;
      if (current != null) {
        _camera = null;
        _notify();
        current.dispose();
      }
    } else if (state == AppLifecycleState.resumed &&
        _camera == null &&
        !_opening) {
      if (_cameras.isEmpty) {
        initialize();
      } else {
        _switchTo(_index);
      }
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _camera?.dispose();
    super.dispose();
  }
}
