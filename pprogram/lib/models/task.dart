// Task model for the SwitchPoint app

import 'package:flutter/material.dart';

enum TaskTag {
  body('Body', Icons.fitness_center),
  study('Study', Icons.book),
  organize('Organize', Icons.cleaning_services),
  creative('Creative', Icons.lightbulb),
  social('Social', Icons.people);

  final String displayName;
  final IconData icon;

  const TaskTag(this.displayName, this.icon);

  static TaskTag fromName(String name) {
    return TaskTag.values.firstWhere(
      (t) => t.displayName == name,
      orElse: () => TaskTag.body,
    );
  }
}

class Task {
  final String id;
  String content;
  TaskTag tag;
  int durationMinutes;
  bool isUserCreated;
  DateTime? lastCompletedAt;
  int completedCount;

  Task({
    required this.id,
    required this.content,
    required this.tag,
    this.durationMinutes = 3,
    this.isUserCreated = true,
    this.lastCompletedAt,
    this.completedCount = 0,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      content: json['content'],
      tag: TaskTag.fromName(json['tag']),
      durationMinutes: json['durationMinutes'] ?? 3,
      isUserCreated: json['isUserCreated'] ?? true,
      lastCompletedAt: json['lastCompletedAt'] != null
          ? DateTime.parse(json['lastCompletedAt'])
          : null,
      completedCount: json['completedCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'tag': tag.displayName,
      'durationMinutes': durationMinutes,
      'isUserCreated': isUserCreated,
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
      'completedCount': completedCount,
    };
  }

  Task copyWith({
    String? content,
    TaskTag? tag,
    int? durationMinutes,
    bool? isUserCreated,
  }) {
    return Task(
      id: id,
      content: content ?? this.content,
      tag: tag ?? this.tag,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isUserCreated: isUserCreated ?? this.isUserCreated,
      lastCompletedAt: lastCompletedAt,
      completedCount: completedCount,
    );
  }
}

// Default system tasks
final List<Task> defaultSystemTasks = [
  Task(id: 'sys_1', content: 'Close eyes and take 10 deep breaths', tag: TaskTag.body, durationMinutes: 1, isUserCreated: false),
  Task(id: 'sys_2', content: 'Drink a glass of water', tag: TaskTag.body, durationMinutes: 1, isUserCreated: false),
  Task(id: 'sys_3', content: 'Do 5 push-ups', tag: TaskTag.body, durationMinutes: 3, isUserCreated: false),
  Task(id: 'sys_4', content: 'Write down one thing to do next', tag: TaskTag.organize, durationMinutes: 1, isUserCreated: false),
  Task(id: 'sys_5', content: 'Organize desk for 3 minutes', tag: TaskTag.organize, durationMinutes: 3, isUserCreated: false),
  Task(id: 'sys_6', content: 'Learn 5 new words', tag: TaskTag.study, durationMinutes: 5, isUserCreated: false),
  Task(id: 'sys_7', content: 'Look out the window for 20 seconds', tag: TaskTag.body, durationMinutes: 1, isUserCreated: false),
  Task(id: 'sys_8', content: 'Draw a simple sketch', tag: TaskTag.creative, durationMinutes: 3, isUserCreated: false),
  Task(id: 'sys_9', content: 'Send a greeting message to a friend', tag: TaskTag.social, durationMinutes: 3, isUserCreated: false),
  Task(id: 'sys_10', content: 'Clean up email for 5 minutes', tag: TaskTag.organize, durationMinutes: 5, isUserCreated: false),
];
