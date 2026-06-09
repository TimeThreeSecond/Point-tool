// Sliding-window tracker for entertainment foreground ratio

import 'dart:async';
import 'foreground_detector.dart';

class EntertainmentTracker {
  final ForegroundDetector _detector;
  final List<String> _entertainmentKeywords;

  // Sliding window configuration
  final int windowSizeSeconds;
  final double triggerThreshold;
  final int minEntertainmentSeconds;

  // Ring buffer: true = entertainment app is foreground
  final List<bool> _buffer;
  int _writeIndex = 0;
  int _entertainmentCount = 0;
  bool _bufferFull = false;

  Timer? _pollTimer;
  bool _running = false;

  // Callbacks
  void Function()? onTrigger;
  void Function(String? title, String? process, double ratio)? onTick;

  EntertainmentTracker({
    required ForegroundDetector detector,
    required List<String> entertainmentKeywords,
    this.windowSizeSeconds = 1800, // 30 min default
    this.triggerThreshold = 0.7, // 70% default
    this.minEntertainmentSeconds = 180, // 3 min default
  })  : _detector = detector,
        _entertainmentKeywords = entertainmentKeywords,
        _buffer = List.filled(windowSizeSeconds, false);

  bool get isRunning => _running;

  double get currentRatio =>
      _entertainmentCount / (_bufferFull ? windowSizeSeconds : _writeIndex);

  int get totalSeconds => _bufferFull ? windowSizeSeconds : _writeIndex;
  int get entertainmentSeconds => _entertainmentCount;

  void updateKeywords(List<String> keywords) {
    _entertainmentKeywords
      ..clear()
      ..addAll(keywords);
  }

  void start() {
    if (_running) return;
    _running = true;
    _pollTimer = Timer.periodic(const Duration(seconds: 1), _onPoll);
  }

  void stop() {
    _running = false;
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void reset() {
    _entertainmentCount = 0;
    _writeIndex = 0;
    _bufferFull = false;
    for (var i = 0; i < _buffer.length; i++) {
      _buffer[i] = false;
    }
  }

  void _onPoll(Timer timer) {
    final title = _detector.getForegroundWindowTitle() ?? '';
    final process = _detector.getForegroundProcessName() ?? '';
    final combined = '$title $process'.toLowerCase();

    final isEntertainment = _entertainmentKeywords.any(
      (kw) => combined.contains(kw.toLowerCase()),
    );

    // Ring buffer update
    if (_bufferFull) {
      if (_buffer[_writeIndex]) _entertainmentCount--;
    }
    _buffer[_writeIndex] = isEntertainment;
    if (isEntertainment) _entertainmentCount++;

    _writeIndex++;
    if (_writeIndex >= windowSizeSeconds) {
      _writeIndex = 0;
      _bufferFull = true;
    }

    final ratio = currentRatio;
    onTick?.call(title, process, ratio);

    // Trigger check
    if (_bufferFull &&
        entertainmentSeconds >= minEntertainmentSeconds &&
        ratio >= triggerThreshold) {
      onTrigger?.call();
      reset();
    }
  }

  void dispose() {
    stop();
    _detector.dispose();
  }
}
