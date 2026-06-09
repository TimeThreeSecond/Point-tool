# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**SwitchPoint (切点)** —个人工具,通过检测娱乐前台占比,在沉迷时用 5 秒打断弹窗把人拔出来。给自己用的,不做商业化。

## Build & Run

```bash
# Flutter CLI (热重载支持)
cd pprogram
flutter run -d windows

# Production build
flutter build windows

# Tests
flutter test

# Fix CMake generator mismatch
rm -rf build/windows && flutter run -d windows
```

**Windows 构建要求**: 需要启用"开发人员模式"(设置→隐私和安全性→ 针对开发人员)以支持插件符号链接。

## 项目结构

```
pprogram/
├── lib/
│   ├── main.dart                          # 入口: 初始化检测 + 系统托盘
│   ├── detection/
│   │   ├── foreground_detector.dart       # 抽象接口(跨平台预留)
│   │   ├── win32_detector.dart            # Win32 FFI 前台窗口检测
│   │   └── entertainment_tracker.dart     # 滑动窗口占比计算 + 触发决策
│   ├── models/
│   │   ├── app_state.dart                 # 中央 ChangeNotifier
│   │   ├── app_state_provider.dart        # InheritedWidget 包装
│   │   ├── settings.dart                  # 娱乐名单 + 检测参数 + 弹窗参数
│   │   ├── task.dart                      # Task + TaskTag + 默认任务池
│   │   └── dice.dart                      # DiceType (纯装饰)
│   ├── pages/
│   │   ├── main_layout.dart               # 侧边栏导航 + 弹窗覆盖层
│   │   ├── settings_page.dart             # 娱乐名单 + 检测参数 + 弹窗设置
│   │   ├── break_popup_page.dart           # 置顶打断弹窗(倒计时+骰子+君子任务)
│   │   ├── detection_page.dart            # 实时前台窗口 + 娱乐占比
│   │   ├── task_manager_page.dart          # 任务 CRUD
│   │   └── stats_page.dart                # 统计(打断次数/连击/时段分布)
│   └── services/
│       ├── dice_service.dart              # 骰子随机(保留供参考)
│       └── task_service.dart              # 任务 CRUD 包装
├── assets/
│   └── icon.ico                           # 系统托盘图标
├── windows/
│   └── CMakeLists.txt                     # MSVC/SDK 路径硬编码
└── pubspec.yaml                           # 依赖: window_manager, system_tray, ffi, path_provider
```

## 核心架构

### 检测 → 触发 → 弹窗 流程

```
Win32ForegroundDetector (每秒轮询 GetForegroundWindow)
         ↓
EntertainmentTracker (滑动窗口占比计算)
  - 1 秒一帧,缓冲区大小 = detectionWindowMinutes × 60
  - 匹配窗口标题/进程名 vs 用户配置的娱乐关键词
  - 当娱乐占比 > threshold AND 累计娱乐 > minMinutes → 触发
         ↓
AppState.triggerBreak()
  - showBreakPopup = true
  - MainLayout 的 Stack 覆盖层显示 BreakPopupPage
  - windowManager 设为置顶 + 固定尺寸 + 禁止关闭
         ↓
BreakPopupPage
  - 8 秒倒计时(按钮禁用)
  - 装饰骰子(可选)
  - 倒计时结束 → 继续工作 / 君子任务(君子协议,自己选完成/未完成)
         ↓
用户关闭弹窗 → windowManager 恢复正常 → 检测继续
```

### 跨平台预留
- `ForegroundDetector` 是抽象接口
- `Win32ForegroundDetector` 是 Windows 实现(FFI 调用 user32.dll/kernel32.dll)
- Android 版本需实现 `UsageStatsManager` 方案

### 状态管理
- `AppState` (ChangeNotifier): 单一数据源
- `AppStateProvider` (InheritedWidget): 透传 appState
- 所有页面通过 `AppStateProvider.of(context)` 获取 + `ListenableBuilder` 监听变化

## 开发状态

- **已完成**: 娱乐前台检测引擎(Win32 FFI)、占比滑动窗口、置顶打断弹窗、君子任务、娱乐名单配置、实时检测状态页
- **待完成**: Android 前台检测、开机自启、勿扰时段逻辑完善、系统托盘图标替换

## 文件命名规范

| 规则 | 示例 |
|------|------|
| 变量 | lowerCamelCase `remainingSeconds` |
| 类名 | UpperCamelCase `BreakPopupPage` |
| 文件名 | lower_snake_case `win32_detector.dart` |
| 产品文档 | 中文 `SwitchPoint_PRD_v1.0.md` |
| 代码注释 | 英文 |
