// Task manager page for the SwitchPoint app

import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/app_state_provider.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../i18n/strings.dart';

class TaskManagerPage extends StatefulWidget {
  const TaskManagerPage({super.key});

  @override
  State<TaskManagerPage> createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  late AppState _appState;
  late TaskService _taskService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = AppStateProvider.of(context);
    _taskService = TaskService(_appState);
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAdd: (content, tag, duration) {
          _taskService.addUserTask(content, tag, durationMinutes: duration);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr.taskManager, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2E))),
                  ElevatedButton.icon(
                    onPressed: _showAddTaskDialog,
                    icon: const Icon(Icons.add),
                    label: Text(tr.addTask),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(tr.userTasks, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2E))),
              const SizedBox(height: 12),
              Expanded(
                flex: 2,
                child: _appState.userTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: _appState.userTasks.length,
                        itemBuilder: (context, index) {
                          final task = _appState.userTasks[index];
                          return _buildTaskCard(task, isUserTask: true);
                        },
                      ),
              ),
              const SizedBox(height: 24),
              Text(tr.systemTasks, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2E))),
              const SizedBox(height: 12),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: defaultSystemTasks.length,
                  itemBuilder: (context, index) {
                    final task = defaultSystemTasks[index];
                    return _buildTaskCard(task, isUserTask: false);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 8),
          Text(tr.noUserTasks, style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, {required bool isUserTask}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTagColor(task.tag),
          child: Icon(task.tag.icon, color: Colors.white, size: 20),
        ),
        title: Text(task.content),
        subtitle: Text('${task.tag.displayName} | ${task.durationMinutes} ${tr.minutes}'),
        trailing: isUserTask
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _taskService.removeTask(task.id),
              )
            : Chip(label: Text(tr.system)),
      ),
    );
  }

  Color _getTagColor(TaskTag tag) {
    switch (tag) {
      case TaskTag.body: return Colors.green;
      case TaskTag.study: return Colors.blue;
      case TaskTag.organize: return Colors.orange;
      case TaskTag.creative: return Colors.purple;
      case TaskTag.social: return Colors.pink;
    }
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(String, TaskTag, int) onAdd;

  const AddTaskDialog({super.key, required this.onAdd});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _contentController = TextEditingController();
  TaskTag _selectedTag = TaskTag.body;
  int _duration = 3;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(tr.addTask),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: 'Task Content', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<TaskTag>(
            value: _selectedTag,
            decoration: const InputDecoration(labelText: 'Tag', border: OutlineInputBorder()),
            items: TaskTag.values.map((tag) {
              return DropdownMenuItem(value: tag, child: Text(tag.displayName));
            }).toList(),
            onChanged: (value) {
              if (value != null) setState(() => _selectedTag = value);
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _duration,
            decoration: const InputDecoration(labelText: 'Duration (min)', border: OutlineInputBorder()),
            items: [1, 3, 5, 10].map((d) {
              return DropdownMenuItem(value: d, child: Text('$d ${tr.minutes}'));
            }).toList(),
            onChanged: (value) {
              if (value != null) setState(() => _duration = value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(tr.cancel)),
        ElevatedButton(
          onPressed: () {
            if (_contentController.text.isNotEmpty) {
              widget.onAdd(_contentController.text, _selectedTag, _duration);
              Navigator.pop(context);
            }
          },
          child: Text(tr.add),
        ),
      ],
    );
  }
}
