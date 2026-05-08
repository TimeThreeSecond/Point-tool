// History record model for the SwitchPoint app

import 'package:flutter/material.dart';
import 'dice.dart';

enum BreakResult {
  skip('Direct Close', Icons.close, Colors.grey),
  reward('Reward', Icons.emoji_events, Colors.amber),
  task('Task', Icons.assignment_turned_in, Colors.blue);

  final String displayName;
  final IconData icon;
  final Color color;

  const BreakResult(this.displayName, this.icon, this.color);
}

class HistoryRecord {
  final String id;
  final DateTime timestamp;
  final DiceType diceType;
  final int? rolledValue;
  final BreakResult result;
  final int? pointsEarned;
  final String? taskContent;
  final int? taskDuration;

  HistoryRecord({
    required this.id,
    required this.timestamp,
    required this.diceType,
    this.rolledValue,
    required this.result,
    this.pointsEarned,
    this.taskContent,
    this.taskDuration,
  });

  factory HistoryRecord.skip({
    required String id,
    DateTime? timestamp,
    required DiceType diceType,
  }) {
    return HistoryRecord(
      id: id,
      timestamp: timestamp ?? DateTime.now(),
      diceType: diceType,
      result: BreakResult.skip,
    );
  }

  factory HistoryRecord.reward({
    required String id,
    DateTime? timestamp,
    required DiceType diceType,
    required int rolledValue,
    required int pointsEarned,
  }) {
    return HistoryRecord(
      id: id,
      timestamp: timestamp ?? DateTime.now(),
      diceType: diceType,
      rolledValue: rolledValue,
      result: BreakResult.reward,
      pointsEarned: pointsEarned,
    );
  }

  factory HistoryRecord.task({
    required String id,
    DateTime? timestamp,
    required DiceType diceType,
    required int rolledValue,
    required String taskContent,
    required int taskDuration,
  }) {
    return HistoryRecord(
      id: id,
      timestamp: timestamp ?? DateTime.now(),
      diceType: diceType,
      rolledValue: rolledValue,
      result: BreakResult.task,
      taskContent: taskContent,
      taskDuration: taskDuration,
    );
  }
}
