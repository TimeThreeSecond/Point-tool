// Main layout with sidebar navigation for the SwitchPoint app

import 'package:flutter/material.dart';
import '../models/app_state.dart';
import 'settings_page.dart';
import 'break_popup_page.dart';
import 'dice_game_page.dart';
import 'task_manager_page.dart';
import 'stats_page.dart';
import 'history_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<NavigationItem> _navItems = [
    NavigationItem(icon: Icons.settings, label: '设置', page: const SettingsPage()),
    NavigationItem(icon: Icons.notifications_active, label: '打断弹窗', page: const BreakPopupPage()),
    NavigationItem(icon: Icons.casino, label: '骰子游戏', page: const DiceGamePage()),
    NavigationItem(icon: Icons.assignment, label: '任务管理', page: const TaskManagerPage()),
    NavigationItem(icon: Icons.bar_chart, label: '统计数据', page: const StatsPage()),
    NavigationItem(icon: Icons.history, label: '历史记录', page: const HistoryPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // App title
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.switch_access_shortcut,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '切点',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'SwitchPoint',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12),
                // Navigation items
                Expanded(
                  child: ListView.builder(
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) {
                      final item = _navItems[index];
                      final isSelected = _selectedIndex == index;
                      return ListTile(
                        leading: Icon(
                          item.icon,
                          color: isSelected ? const Color(0xFF6366F1) : Colors.white54,
                        ),
                        title: Text(
                          item.label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white54,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedTileColor: const Color(0xFF6366F1).withOpacity(0.1),
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
                // Bottom info
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    children: [
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          color: Colors.white24,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'MVP 阶段',
                        style: TextStyle(
                          color: Colors.white24,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F7),
              child: _navItems[_selectedIndex].page,
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Widget page;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.page,
  });
}
