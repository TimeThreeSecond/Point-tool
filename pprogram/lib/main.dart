import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:system_tray/system_tray.dart';
import 'models/app_state.dart';
import 'models/app_state_provider.dart';
import 'pages/main_layout.dart';
import 'detection/win32_detector.dart';
import 'detection/entertainment_tracker.dart';
import 'i18n/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final appState = AppState();
  setLanguage(appState.language);
  _startDetection(appState);
  await _initSystemTray(appState);

  runApp(
    AppStateProvider(
      appState: appState,
      child: const SwitchPointApp(),
    ),
  );
}

void _startDetection(AppState appState) {
  final detector = Win32ForegroundDetector();
  final tracker = EntertainmentTracker(
    detector: detector,
    entertainmentKeywords: appState.settings.entertainmentKeywords,
    windowSizeSeconds: appState.settings.detectionWindowMinutes * 60,
    triggerThreshold: appState.settings.triggerThreshold,
    minEntertainmentSeconds: appState.settings.minEntertainmentMinutes * 60,
  );

  tracker.onTick = (title, process, ratio) {
    appState.updateForeground(title, process, ratio);
  };

  tracker.onTrigger = () {
    appState.triggerBreak();
    windowManager.show();
    windowManager.focus();
  };

  tracker.start();
}

final SystemTray _systemTray = SystemTray();

Future<void> _initSystemTray(AppState appState) async {
  try {
    await _systemTray.initSystemTray(
      iconPath: '${Directory.current.path}/assets/icon.ico',
      toolTip: 'SwitchPoint - 切点',
    );

    final menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(
        label: tr.openSwitchPoint,
        onClicked: (_) async {
          await windowManager.show();
          await windowManager.focus();
        },
      ),
      MenuItemLabel(
        label: tr.quit,
        onClicked: (_) async {
          await _systemTray.destroy();
          await windowManager.destroy();
        },
      ),
    ]);
    await _systemTray.setContextMenu(menu);
  } catch (_) {
    // System tray is non-critical; skip on failure
  }
}

class SwitchPointApp extends StatelessWidget {
  const SwitchPointApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwitchPoint - 切点',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainLayout(),
    );
  }
}
