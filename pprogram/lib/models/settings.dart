// App settings model for the SwitchPoint app

class AppSettings {
  // Entertainment detection
  List<String> entertainmentKeywords;
  int detectionWindowMinutes;
  double triggerThreshold;
  int minEntertainmentMinutes;

  // Break popup
  int forceWaitSeconds;
  bool showDice;

  // Do not disturb
  bool doNotDisturbEnabled;
  TimeOfDay? doNotDisturbStart;
  TimeOfDay? doNotDisturbEnd;

  AppSettings({
    this.entertainmentKeywords = const ['chrome', 'edge', 'video', '哔哩哔哩', '抖音'],
    this.detectionWindowMinutes = 30,
    this.triggerThreshold = 0.7,
    this.minEntertainmentMinutes = 3,
    this.forceWaitSeconds = 8,
    this.showDice = true,
    this.doNotDisturbEnabled = false,
    this.doNotDisturbStart,
    this.doNotDisturbEnd,
  });

  factory AppSettings.defaultSettings() {
    return AppSettings(
      entertainmentKeywords: ['chrome', 'edge', 'video', '哔哩哔哩', '抖音'],
      detectionWindowMinutes: 30,
      triggerThreshold: 0.7,
      minEntertainmentMinutes: 3,
      forceWaitSeconds: 8,
      showDice: true,
      doNotDisturbEnabled: false,
      doNotDisturbStart: const TimeOfDay(hour: 22, minute: 0),
      doNotDisturbEnd: const TimeOfDay(hour: 8, minute: 0),
    );
  }

  AppSettings copyWith({
    List<String>? entertainmentKeywords,
    int? detectionWindowMinutes,
    double? triggerThreshold,
    int? minEntertainmentMinutes,
    int? forceWaitSeconds,
    bool? showDice,
    bool? doNotDisturbEnabled,
    TimeOfDay? doNotDisturbStart,
    TimeOfDay? doNotDisturbEnd,
  }) {
    return AppSettings(
      entertainmentKeywords: entertainmentKeywords ?? this.entertainmentKeywords,
      detectionWindowMinutes: detectionWindowMinutes ?? this.detectionWindowMinutes,
      triggerThreshold: triggerThreshold ?? this.triggerThreshold,
      minEntertainmentMinutes: minEntertainmentMinutes ?? this.minEntertainmentMinutes,
      forceWaitSeconds: forceWaitSeconds ?? this.forceWaitSeconds,
      showDice: showDice ?? this.showDice,
      doNotDisturbEnabled: doNotDisturbEnabled ?? this.doNotDisturbEnabled,
      doNotDisturbStart: doNotDisturbStart ?? this.doNotDisturbStart,
      doNotDisturbEnd: doNotDisturbEnd ?? this.doNotDisturbEnd,
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
