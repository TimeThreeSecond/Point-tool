// Task service for the SwitchPoint app

import '../models/task.dart';
import '../models/app_state.dart';
import '../i18n/strings.dart';

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
      throw Exception(tr.atLeastOneTask);
    }
    appState.removeTask(taskId);
  }

  void completeTask(Task task) {
    appState.completeTask(task);
  }
}
