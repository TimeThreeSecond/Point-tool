// Abstract interface for platform-specific foreground window detection

abstract class ForegroundDetector {
  /// Get the title of the currently focused window. Returns null on error.
  String? getForegroundWindowTitle();

  /// Get the executable name of the currently focused process. Returns null on error.
  String? getForegroundProcessName();

  void dispose();
}
