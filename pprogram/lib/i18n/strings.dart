// Chinese/English bilingual strings for SwitchPoint

import '../models/app_state.dart';

Strings? _current;

Strings get tr => _current ?? Strings.zh;

void setLanguage(Language lang) {
  _current = lang == Language.zh ? Strings.zh : Strings.en;
}

class Strings {
  final String Function(String key) _t;

  const Strings._(this._t);

  String call(String key) => _t(key);

  // ── main_layout ──
  String get appTitle => _t('appTitle');
  String get navSettings => _t('navSettings');
  String get navDetection => _t('navDetection');
  String get navTasks => _t('navTasks');
  String get navStats => _t('navStats');
  String get running => _t('running');
  String get stopped => _t('stopped');

  // ── settings_page ──
  String get settings => _t('settings');
  String get liveDetection => _t('liveDetection');
  String get currentWindow => _t('currentWindow');
  String get process => _t('process');
  String get entertainmentRatio => _t('entertainmentRatio');
  String get windowAndThresholdSummary => _t('windowAndThresholdSummary');
  String get entertainmentApps => _t('entertainmentApps');
  String get entertainmentAppsHint => _t('entertainmentAppsHint');
  String get add => _t('add');
  String get addKeyword => _t('addKeyword');
  String get keywordHint => _t('keywordHint');
  String get cancel => _t('cancel');
  String get detectionParams => _t('detectionParams');
  String get detectionWindow => _t('detectionWindow');
  String get triggerThreshold => _t('triggerThreshold');
  String get minEntertainment => _t('minEntertainment');
  String get minutes => _t('minutes');
  String get percent => _t('percent');
  String get popupSettings => _t('popupSettings');
  String get forceWait => _t('forceWait');
  String get seconds => _t('seconds');
  String get showDice => _t('showDice');
  String get showDiceHint => _t('showDiceHint');
  String get doNotDisturb => _t('doNotDisturb');
  String get enableDnd => _t('enableDnd');
  String get dndHint => _t('dndHint');
  String get startTime => _t('startTime');
  String get endTime => _t('endTime');
  String get language => _t('language');
  String get langName => _t('langName');

  // ── break_popup ──
  String get takeABreak => _t('takeABreak');
  String get timesUp => _t('timesUp');
  String get breathe => _t('breathe');
  String get youAreGood => _t('youAreGood');
  String get tapDice => _t('tapDice');
  String get tapAgain => _t('tapAgain');
  String get continueWorking => _t('continueWorking');
  String get waitSeconds => _t('waitSeconds');
  String get rollDice => _t('rollDice');
  String get honorTask => _t('honorTask');
  String get done => _t('done');
  String get notYet => _t('notYet');
  String get honorPrompt => _t('honorPrompt');
  String get wellDone => _t('wellDone');
  String get streakPlusOne => _t('streakPlusOne');

  // ── detection_page ──
  String get detection => _t('detection');
  String get detectionSubtitle => _t('detectionSubtitle');
  String get waiting => _t('waiting');
  String get breaksToday => _t('breaksToday');
  String get tasksDone => _t('tasksDone');
  String get dayStreak => _t('dayStreak');
  String get triggered => _t('triggered');
  String get triggerHint => _t('triggerHint');

  // ── task_manager ──
  String get taskManager => _t('taskManager');
  String get addTask => _t('addTask');
  String get userTasks => _t('userTasks');
  String get systemTasks => _t('systemTasks');
  String get noUserTasks => _t('noUserTasks');
  String get system => _t('system');

  // ── stats_page ──
  String get stats => _t('stats');
  String get times => _t('times');
  String get days => _t('days');
  String get streak => _t('streak');
  String get currentStreak => _t('currentStreak');
  String get best => _t('best');
  String get hourlyDist => _t('hourlyDist');
  String get hourlyDistHint => _t('hourlyDistHint');

  // ── system_tray ──
  String get openSwitchPoint => _t('openSwitchPoint');
  String get quit => _t('quit');

  // ── task_service ──
  String get atLeastOneTask => _t('atLeastOneTask');

  // ── ZH ──
  static const _zhMap = <String, String>{
    // main_layout
    'appTitle': '切点',
    'navSettings': '设置',
    'navDetection': '检测状态',
    'navTasks': '君子任务',
    'navStats': '统计',
    'running': '运行中',
    'stopped': '未启动',
    // settings_page
    'settings': '设置',
    'liveDetection': '实时检测',
    'currentWindow': '当前窗口',
    'process': '进程',
    'entertainmentRatio': '娱乐占比',
    'windowAndThresholdSummary': '检测窗口: {w}分 · 触发阈值: {t}% · 今日打断: {b}次',
    'entertainmentApps': '娱乐软件名单',
    'entertainmentAppsHint': '当前窗口标题或进程名包含以下关键词时计入娱乐时间',
    'add': '添加',
    'addKeyword': '添加关键词',
    'keywordHint': '输入窗口标题或进程名关键词',
    'cancel': '取消',
    'detectionParams': '检测参数',
    'detectionWindow': '检测时间窗口',
    'triggerThreshold': '触发阈值',
    'minEntertainment': '最少累计娱乐时间',
    'minutes': '分钟',
    'percent': '%',
    'popupSettings': '弹窗设置',
    'forceWait': '强制等待时长',
    'seconds': '秒',
    'showDice': '显示骰子',
    'showDiceHint': '弹窗中显示可交互的骰子装饰',
    'doNotDisturb': '勿扰模式',
    'enableDnd': '启用勿扰模式',
    'dndHint': '在设定时段内不触发打断',
    'startTime': '开始时间',
    'endTime': '结束时间',
    'language': '语言',
    'langName': '中文',
    // break_popup
    'takeABreak': '休息一下',
    'timesUp': '时间到',
    'breathe': '深呼吸...',
    'youAreGood': '可以了',
    'tapDice': '点一下骰子玩玩',
    'tapAgain': '再点一下',
    'continueWorking': '继续工作',
    'waitSeconds': '等待 {s}s',
    'rollDice': '掷骰子',
    'honorTask': '君子任务',
    'done': '已完成',
    'notYet': '没完成',
    'honorPrompt': '做完了选「已完成」，没做完选「没完成」\n纯君子协议，自己对自己诚实就好',
    'wellDone': '做得好！',
    'streakPlusOne': '连击天数 +1',
    // detection_page
    'detection': '检测状态',
    'detectionSubtitle': '实时查看当前前台窗口和娱乐占比',
    'waiting': '等待检测...',
    'breaksToday': '今日打断',
    'tasksDone': '完成任务',
    'dayStreak': '连击天数',
    'triggered': '⚠️ 已达到触发阈值',
    'triggerHint': '最低{m}分钟娱乐时间后触发',
    // task_manager
    'taskManager': '任务管理',
    'addTask': '添加任务',
    'userTasks': '用户任务',
    'systemTasks': '系统任务',
    'noUserTasks': '暂无用户任务',
    'system': '系统预设',
    // stats_page
    'stats': '统计',
    'times': '次',
    'days': '天',
    'streak': '连击记录',
    'currentStreak': '当前连击天数',
    'best': '最高纪录',
    'hourlyDist': '时段分布',
    'hourlyDistHint': '一天中哪些时段容易触发打断',
    // system_tray
    'openSwitchPoint': '打开 SwitchPoint',
    'quit': '退出',
    // task_service
    'atLeastOneTask': '至少需要保留一个任务',
  };

  static const _enMap = <String, String>{
    // main_layout
    'appTitle': 'SwitchPoint',
    'navSettings': 'Settings',
    'navDetection': 'Detection',
    'navTasks': 'Tasks',
    'navStats': 'Stats',
    'running': 'Running',
    'stopped': 'Stopped',
    // settings_page
    'settings': 'Settings',
    'liveDetection': 'Live Detection',
    'currentWindow': 'Current Window',
    'process': 'Process',
    'entertainmentRatio': 'Entertainment Ratio',
    'windowAndThresholdSummary': 'Window: {w}min · Threshold: {t}% · Today: {b} breaks',
    'entertainmentApps': 'Entertainment Apps',
    'entertainmentAppsHint': 'Window titles or process names containing these keywords count as entertainment',
    'add': 'Add',
    'addKeyword': 'Add Keyword',
    'keywordHint': 'Enter window title or process name keyword',
    'cancel': 'Cancel',
    'detectionParams': 'Detection Settings',
    'detectionWindow': 'Detection Window',
    'triggerThreshold': 'Trigger Threshold',
    'minEntertainment': 'Min Entertainment Time',
    'minutes': 'min',
    'percent': '%',
    'popupSettings': 'Popup Settings',
    'forceWait': 'Force Wait',
    'seconds': 'sec',
    'showDice': 'Show Dice',
    'showDiceHint': 'Show interactive dice in the popup',
    'doNotDisturb': 'Do Not Disturb',
    'enableDnd': 'Enable DND',
    'dndHint': 'No interruptions during set hours',
    'startTime': 'Start Time',
    'endTime': 'End Time',
    'language': 'Language',
    'langName': 'English',
    // break_popup
    'takeABreak': 'Take a break',
    'timesUp': "Time's up",
    'breathe': 'Breathe...',
    'youAreGood': "You're good",
    'tapDice': 'Tap the dice',
    'tapAgain': 'Tap again',
    'continueWorking': 'Continue',
    'waitSeconds': 'Wait {s}s',
    'rollDice': 'Roll Dice',
    'honorTask': 'Task',
    'done': 'Done',
    'notYet': 'Not Yet',
    'honorPrompt': 'Pick "Done" if you did it, "Not Yet" if not.\nHonor system — be honest with yourself.',
    'wellDone': 'Well done!',
    'streakPlusOne': 'Streak +1',
    // detection_page
    'detection': 'Detection',
    'detectionSubtitle': 'Real-time foreground window and entertainment ratio',
    'waiting': 'Waiting...',
    'breaksToday': 'Breaks Today',
    'tasksDone': 'Tasks Done',
    'dayStreak': 'Day Streak',
    'triggered': '⚠️ Trigger threshold reached',
    'triggerHint': 'Triggers after {m}min of entertainment',
    // task_manager
    'taskManager': 'Task Manager',
    'addTask': 'Add Task',
    'userTasks': 'User Tasks',
    'systemTasks': 'System Tasks',
    'noUserTasks': 'No user tasks yet',
    'system': 'System',
    // stats_page
    'stats': 'Stats',
    'times': 'times',
    'days': 'days',
    'streak': 'Streak',
    'currentStreak': 'Current Streak',
    'best': 'Best',
    'hourlyDist': 'Hourly Distribution',
    'hourlyDistHint': 'When breaks trigger most during the day',
    // system_tray
    'openSwitchPoint': 'Open SwitchPoint',
    'quit': 'Quit',
    // task_service
    'atLeastOneTask': 'At least one task is required',
  };

  static final Strings zh = Strings._((String key) => _zhMap[key] ?? key);
  static final Strings en = Strings._((String key) => _enMap[key] ?? key);
}

extension StringFormat on String {
  String format(Map<String, dynamic> params) {
    var result = this;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    return result;
  }
}
