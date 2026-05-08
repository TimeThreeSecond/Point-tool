// Task service for the SwitchPoint app

import '../models/task.dart';
import '../models/app_state.dart';

class TaskService {
  final AppState appState;

  TaskService(this.appState);

  void addUserTask(String content, TaskTag tag, {int durationMinutes = 3}) {
    final task = Task(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      tag: tag,
      durationMinutes: durationMinutes,
      isUserCreated: true,
    );
    appState.addTask(task);
  }

  void updateTask(Task task) {
    appState.updateTask(task);
  }

  void removeTask(String taskId) {
    // Ensure at least one task remains
    if (appState.userTasks.length + defaultSystemTasks.length <= 1) {
      throw Exception('至少需要保留一个任务');
    }
    appState.removeTask(taskId);
  }

  Task? drawRandomTask() {
    return appState.drawRandomTask();
  }

  void completeTask(Task task) {
    appState.completeTask(task);
  }
}
