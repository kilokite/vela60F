import 'package:flutter_test/flutter_test.dart';
import 'package:vela60f/record/recording_controller.dart';

void main() {
  testWidgets('stop rewinds non-linearly back to 10 minutes', (tester) async {
    final controller = RecordingController(vsync: const TestVSync());
    addTearDown(controller.dispose);

    controller.start();
    await tester.pump();
    await tester.pump(const Duration(minutes: 2));
    expect(controller.isRecording, isTrue);
    expect(controller.remainingMinutes, closeTo(8, 0.05));

    controller.stop();
    expect(controller.isRecording, isFalse);
    await tester.pump();
    final from = controller.remainingMinutes;

    await tester.pump(const Duration(milliseconds: 100));
    final early = controller.remainingMinutes;
    // easeOutQuart 在 100ms 已经走完大半；线性只会到 from + 0.43。
    expect(early, greaterThan(from + (10 - from) * 0.5));

    await tester.pump(const Duration(seconds: 2));
    expect(controller.remainingMinutes, closeTo(10, 0.0001));
    expect(controller.isRecording, isFalse);
  });

  testWidgets('auto end also rewinds from 0 to 10 minutes', (tester) async {
    final controller = RecordingController(vsync: const TestVSync());
    addTearDown(controller.dispose);

    controller.start();
    await tester.pump();
    await tester.pump(const Duration(minutes: 10, seconds: 1));
    expect(controller.isRecording, isFalse);

    await tester.pump(const Duration(seconds: 2));
    expect(controller.remainingMinutes, closeTo(10, 0.0001));
  });
}
