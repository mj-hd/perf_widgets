import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GestureArenaDetector extends StatelessWidget {
  const GestureArenaDetector({
    Key? key,
    this.onGestureArenaHeld,
    this.onGestureArenaReleased,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onGestureArenaHeld;
  final VoidCallback? onGestureArenaReleased;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        _GestureArenaDetectorRecognizer: GestureRecognizerFactoryWithHandlers<
            _GestureArenaDetectorRecognizer>(
          _GestureArenaDetectorRecognizer.new,
          (recognizer) {
            recognizer.onGestureArenaHeld = onGestureArenaHeld;
            recognizer.onGestureArenaReleased = onGestureArenaReleased;
          },
        ),
      },
      excludeFromSemantics: true,
      child: child,
    );
  }
}

class _GestureArenaDetectorRecognizer extends OneSequenceGestureRecognizer {
  _GestureArenaDetectorRecognizer();

  VoidCallback? onGestureArenaHeld;
  VoidCallback? onGestureArenaReleased;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    onGestureArenaHeld?.call();
    stopTrackingPointer(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {}

  @override
  void acceptGesture(int pointer) {
    onGestureArenaReleased?.call();
  }

  @override
  void rejectGesture(int pointer) {
    onGestureArenaReleased?.call();
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  final debugDescription = 'GestureArenaDetectorRecognizer';
}
