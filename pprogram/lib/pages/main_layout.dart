// Main layout with sidebar navigation

import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/app_state_provider.dart';
import '../i18n/strings.dart';
import 'settings_page.dart';
import 'break_popup_page.dart';
import 'detection_page.dart';
import 'task_manager_page.dart';
import 'stats_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Stack(
          children: [
            Scaffold(
              body: Row(
                children: [
                  _buildSidebar(appState),
                  Expanded(child: _pages[_selectedIndex]),
                ],
              ),
            ),
            if (appState.showBreakPopup) const BreakPopupPage(),
          ],
        );
      },
    );
  }

  static const _pages = <Widget>[
    SettingsPage(),
    DetectionPage(),
    TaskManagerPage(),
    StatsPage(),
  ];

  Widget _buildSidebar(AppState state) {
    return Container(
      width: 180,
      decoration: const BoxDecoration(color: Color(0xFF1E1E2E)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.switch_access_shortcut, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      tr.appTitle,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: Column(
              children: [
                _buildNavItem(0, Icons.settings, tr.navSettings),
                _buildNavItem(1, Icons.monitor_heart, tr.navDetection),
                _buildNavItem(2, Icons.assignment, tr.navTasks),
                _buildNavItem(3, Icons.bar_chart, tr.navStats),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: state.detectionActive ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  state.detectionActive ? tr.running : tr.stopped,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final selected = _selectedIndex == index;
    return ListTile(
      dense: true,
      leading: Icon(icon, color: selected ? const Color(0xFF6366F1) : Colors.white54, size: 20),
      title: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.white54, fontSize: 14)),
      selected: selected,
      selectedTileColor: const Color(0xFF6366F1).withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () => setState(() => _selectedIndex = index),
    );
  }
}
