// App state model for the SwitchPoint app

import 'package:flutter/material.dart';
import 'settings.dart';
import 'task.dart';
import 'dice.dart';
import 'history_record.dart';

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
  List<Task> get tasksForDraw => allTasks.where((t) {
    if (t.lastCompletedAt == null) return true;
    final hoursSince = DateTime.now().difference(t.lastCompletedAt!).inHours;
    return hoursSince >= 24;
  }).toList();

  // Stats
  int totalPoints = 0;
  int totalRolls = 0;
  int totalTasksAccepted = 0;
  int totalSkips = 0;
  int currentStreak = 0;
  int maxStreak = 0;

  // History
  List<HistoryRecord> history = [];

  // Current break
  DiceType? currentBreakDice;
  int? currentRolledValue;
  bool? currentIsReward;
  Task? currentTask;

  // Break popup countdown
  int _breakCountdownSeconds = 0;
  int get breakCountdownSeconds => _breakCountdownSeconds;

  void setMode(AppMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  void setRemainingSeconds(int seconds) {
    _remainingSeconds = seconds;
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

  void addHistoryRecord(HistoryRecord record) {
    history.insert(0, record);
    if (history.length > 100) {
      history = history.sublist(0, 100);
    }
    notifyListeners();
  }

  void addPoints(int points) {
    totalPoints += points;
    notifyListeners();
  }

  void incrementRolls() {
    totalRolls++;
    notifyListeners();
  }

  void incrementTasksAccepted() {
    totalTasksAccepted++;
    currentStreak++;
    if (currentStreak > maxStreak) {
      maxStreak = currentStreak;
    }
    notifyListeners();
  }

  void incrementSkips() {
    totalSkips++;
    currentStreak = 0;
    notifyListeners();
  }

  void completeTask(Task task) {
    task.lastCompletedAt = DateTime.now();
    task.completedCount++;
    notifyListeners();
  }

  Task? drawRandomTask() {
    final available = tasksForDraw;
    if (available.isEmpty) return null;
    // 70% user tasks, 30% system tasks
    final userTasksPool = available.where((t) => t.isUserCreated).toList();
    final systemTasksPool = available.where((t) => !t.isUserCreated).toList();
    
    if (userTasksPool.isNotEmpty && (systemTasksPool.isEmpty || DateTime.now().millisecond % 10 < 7)) {
      final index = DateTime.now().millisecond % userTasksPool.length;
      return userTasksPool[index];
    } else if (systemTasksPool.isNotEmpty) {
      final index = DateTime.now().millisecond % systemTasksPool.length;
      return systemTasksPool[index];
    }
    return null;
  }

  void setCurrentBreak({
    DiceType? dice,
    int? rolledValue,
    bool? isReward,
    Task? task,
  }) {
    currentBreakDice = dice;
    currentRolledValue = rolledValue;
    currentIsReward = isReward;
    currentTask = task;
    notifyListeners();
  }

  void clearCurrentBreak() {
    currentBreakDice = null;
    currentRolledValue = null;
    currentIsReward = null;
    currentTask = null;
    notifyListeners();
  }
}
