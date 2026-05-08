// App settings model for the SwitchPoint app

import 'dice.dart';

class AppSettings {
  int workDurationMinutes;
  int restDurationMinutes;
  int forceWaitSeconds;
  DiceType defaultDice;
  bool doNotDisturbEnabled;
  TimeOfDay? doNotDisturbStart;
  TimeOfDay? doNotDisturbEnd;
  bool fullscreenDetectionEnabled;

  AppSettings({
    this.workDurationMinutes = 30,
    this.restDurationMinutes = 5,
    this.forceWaitSeconds = 8,
    this.defaultDice = DiceType.d6,
    this.doNotDisturbEnabled = false,
    this.doNotDisturbStart,
    this.doNotDisturbEnd,
    this.fullscreenDetectionEnabled = true,
  });

  factory AppSettings.defaultSettings() {
    return AppSettings(
      workDurationMinutes: 30,
      restDurationMinutes: 5,
      forceWaitSeconds: 8,
      defaultDice: DiceType.d6,
      doNotDisturbEnabled: false,
      doNotDisturbStart: const TimeOfDay(hour: 22, minute: 0),
      doNotDisturbEnd: const TimeOfDay(hour: 8, minute: 0),
      fullscreenDetectionEnabled: true,
    );
  }

  AppSettings copyWith({
    int? workDurationMinutes,
    int? restDurationMinutes,
    int? forceWaitSeconds,
    DiceType? defaultDice,
    bool? doNotDisturbEnabled,
    TimeOfDay? doNotDisturbStart,
    TimeOfDay? doNotDisturbEnd,
    bool? fullscreenDetectionEnabled,
  }) {
    return AppSettings(
      workDurationMinutes: workDurationMinutes ?? this.workDurationMinutes,
      restDurationMinutes: restDurationMinutes ?? this.restDurationMinutes,
      forceWaitSeconds: forceWaitSeconds ?? this.forceWaitSeconds,
      defaultDice: defaultDice ?? this.defaultDice,
      doNotDisturbEnabled: doNotDisturbEnabled ?? this.doNotDisturbEnabled,
      doNotDisturbStart: doNotDisturbStart ?? this.doNotDisturbStart,
      doNotDisturbEnd: doNotDisturbEnd ?? this.doNotDisturbEnd,
      fullscreenDetectionEnabled: fullscreenDetectionEnabled ?? this.fullscreenDetectionEnabled,
    );
  }
}

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  @override
  String toString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
