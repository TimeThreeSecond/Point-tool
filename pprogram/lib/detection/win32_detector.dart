// Windows implementation of ForegroundDetector using Win32 FFI

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'foreground_detector.dart';

final DynamicLibrary _user32 = DynamicLibrary.open('user32.dll');
final DynamicLibrary _kernel32 = DynamicLibrary.open('kernel32.dll');

final int Function() _getForegroundWindow = _user32
    .lookupFunction<IntPtr Function(), int Function()>('GetForegroundWindow');

final int Function(int, Pointer<Utf16>, int) _getWindowText = _user32
    .lookupFunction<Int32 Function(IntPtr, Pointer<Utf16>, Int32),
        int Function(int, Pointer<Utf16>, int)>('GetWindowTextW');

final int Function(int, Pointer<Uint32>) _getWindowThreadProcessId = _user32
    .lookupFunction<Uint32 Function(IntPtr, Pointer<Uint32>),
        int Function(int, Pointer<Uint32>)>('GetWindowThreadProcessId');

final DynamicLibrary _psapi = DynamicLibrary.open('psapi.dll');

final int Function(int, Pointer<Utf16>, int) _getModuleBaseName = _psapi
    .lookupFunction<Uint32 Function(IntPtr, Pointer<Utf16>, Uint32),
        int Function(int, Pointer<Utf16>, int)>('GetModuleBaseNameW');

final int Function(int, int, int) _openProcess = _kernel32
    .lookupFunction<IntPtr Function(Uint32, Int32, Uint32),
        int Function(int, int, int)>('OpenProcess');

final int Function(int) _closeHandle = _kernel32
    .lookupFunction<Int32 Function(IntPtr), int Function(int)>('CloseHandle');

class Win32ForegroundDetector implements ForegroundDetector {
  @override
  String? getForegroundWindowTitle() {
    final hwnd = _getForegroundWindow();
    if (hwnd == 0) return null;

    final buffer = calloc<Uint16>(256);
    final length = _getWindowText(hwnd, buffer.cast<Utf16>(), 256);
    if (length == 0) {
      calloc.free(buffer);
      return null;
    }
    final title = String.fromCharCodes(buffer.asTypedList(length));
    calloc.free(buffer);
    return title;
  }

  @override
  String? getForegroundProcessName() {
    final hwnd = _getForegroundWindow();
    if (hwnd == 0) return null;

    final pidPtr = calloc<Uint32>(1);
    _getWindowThreadProcessId(hwnd, pidPtr);
    final pid = pidPtr.value;
    calloc.free(pidPtr);

    final hProcess =
        _openProcess(0x0400 | 0x0010, 0, pid); // PROCESS_QUERY_INFORMATION | PROCESS_VM_READ
    if (hProcess == 0) return null;

    final buffer = calloc<Uint16>(260);
    final length = _getModuleBaseName(hProcess, buffer.cast<Utf16>(), 260);
    _closeHandle(hProcess);

    if (length == 0) {
      calloc.free(buffer);
      return null;
    }
    final name = String.fromCharCodes(buffer.asTypedList(length)).toLowerCase();
    calloc.free(buffer);
    return name;
  }

  @override
  void dispose() {}
}
