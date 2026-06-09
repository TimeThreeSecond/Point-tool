// App state model for the SwitchPoint app

import 'package:flutter/material.dart';
import 'settings.dart';
import 'task.dart';
import '../i18n/strings.dart';

enum Language { zh, en }

enum AppMode {
  idle('待机', Icons.pause_circle_outline, Colors.grey),
  working('工作中', Icons.timer, Color(0xFF6366F1)),
  breaking('打断提醒', Icons.notifications_active, Colors.orange),
  resting('休息中', Icons.coffee, Colors.green),
  tasking('任务中', Icons.assignment, Colors.blue);

  final String displayName;
  final IconData icon;
  final Color color;

  const AppMode(this.displayName, this.icon, this.color);
}

class AppState extends ChangeNotifier {
  // Settings
  AppSettings settings = AppSettings.defaultSettings();

  // App mode
  AppMode _currentMode = AppMode.idle;
  AppMode get currentMode => _currentMode;

  // Timer
  int _remainingSeconds = 0;
  int get remainingSeconds => _remainingSeconds;
  String get remainingTimeText {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Tasks
  List<Task> userTasks = [];
  List<Task> get allTasks => [...userTasks, ...defaultSystemTasks];

  // Stats (simplified)
  int todayBreaks = 0;
  int tasksCompleted = 0;
  int currentStreakDays = 0;
  int maxStreakDays = 0;

  // Detection state
  String? currentForegroundTitle;
  String? currentForegroundProcess;
  double entertainmentRatio = 0.0;
  bool detectionActive = false;

  // Break popup state
  bool showBreakPopup = false;
  int _breakCountdownSeconds = 0;
  int get breakCountdownSeconds => _breakCountdownSeconds;
  Task? currentTask;

  // Language
  Language _language = Language.zh;
  Language get language => _language;

  // Today's date for streak tracking
  DateTime _lastBreakDate = DateTime.now().subtract(const Duration(days: 1));
  List<int> hourlyTriggers = List.filled(24, 0);

  void setMode(AppMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  void setBreakCountdown(int seconds) {
    _breakCountdownSeconds = seconds;
    notifyListeners();
  }

  void updateSettings(AppSettings newSettings) {
    settings = newSettings;
    notifyListeners();
  }

  void toggleLanguage() {
    _language = _language == Language.zh ? Language.en : Language.zh;
    setLanguage(_language);
    notifyListeners();
  }

  // Detection updates (called from tracker onTick)
  void updateForeground(String? title, String? process, double ratio) {
    currentForegroundTitle = title;
    currentForegroundProcess = process;
    entertainmentRatio = ratio;
    detectionActive = true;
    notifyListeners();
  }

  // Trigger break popup
  void triggerBreak() {
    showBreakPopup = true;
    todayBreaks++;
    _breakCountdownSeconds = settings.forceWaitSeconds;
    setMode(AppMode.breaking);

    // Update hourly trigger distribution
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 24) hourlyTriggers[hour]++;

    // Update streak
    final today = DateTime.now();
    if (_lastBreakDate.day != today.day || _lastBreakDate.month != today.month) {
      if (today.difference(_lastBreakDate).inDays <= 1) {
        currentStreakDays++;
      } else {
        currentStreakDays = 1;
      }
      if (currentStreakDays > maxStreakDays) {
        maxStreakDays = currentStreakDays;
      }
      _lastBreakDate = today;
    }

    notifyListeners();
  }

  void dismissBreak() {
    showBreakPopup = false;
    _breakCountdownSeconds = 0;
    currentTask = null;
    setMode(AppMode.idle);
    notifyListeners();
  }

  void completeTask(Task task) {
    tasksCompleted++;
    task.lastCompletedAt = DateTime.now();
    task.completedCount++;
    notifyListeners();
  }

  void assignRandomTask() {
    final available = allTasks;
    if (available.isEmpty) {
      currentTask = null;
      return;
    }
    final index = DateTime.now().millisecondsSinceEpoch % available.length;
    currentTask = available[index];
    notifyListeners();
  }

  // Task management
  void addTask(Task task) {
    userTasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    final index = userTasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      userTasks[index] = task;
      notifyListeners();
    }
  }

  void removeTask(String taskId) {
    userTasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }
}
