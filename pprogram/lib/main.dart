import 'package:flutter/material.dart';
import 'models/app_state.dart';
import 'models/app_state_provider.dart';
import 'pages/main_layout.dart';

void main() {
  runApp(const SwitchPointApp());
}

class SwitchPointApp extends StatelessWidget {
  const SwitchPointApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    
    return AppStateProvider(
      appState: appState,
      child: MaterialApp(
        title: 'SwitchPoint - 切点',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Inter',
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
      ),
    );
  }
}
