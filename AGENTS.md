# 切点 (SwitchPoint) — Agent 开发指南

> 本文档面向 AI Coding Agent。阅读本文档前，请勿对项目做任何假设。

---

## 1. 项目概述

**切点 (SwitchPoint)** 是一款面向个人的「休闲效率工具」，核心目标是通过低侵入性的娱乐化打断机制，帮助用户从短视频等沉浸式娱乐场景中自然脱离，并为工作/学习状态提供软着陆入口。

- **产品代号**: `pprogram`（Flutter 项目名）
- **目标平台**: Windows 桌面端（Phase 1）→ Android（Phase 2）
- **当前阶段**: MVP 初期，项目骨架阶段（W1）
- **PRD**: 见根目录 `SwitchPoint_PRD_v1.0.md`，为开发唯一依据

当前代码库中，Flutter 应用仍停留在默认模板阶段（计数器 Demo），核心业务逻辑（计时器、骰子、任务系统、托盘等）均尚未实现。

---

## 2. 技术栈

| 层级 | 技术 | 说明 |
|------|------|------|
| 框架 | **Flutter** | 跨平台，当前仅启用 Windows 支持 |
| 语言 | Dart | SDK 约束 `^3.11.5` |
| 状态管理 | （规划中）flutter_riverpod | PRD 指定，尚未引入 |
| 本地存储 | （规划中）Hive | PRD 指定，尚未引入 |
| 窗口管理 | （规划中）window_manager | PRD 指定，尚未引入 |
| 系统托盘 | （规划中）system_tray | PRD 指定，尚未引入 |
| 3D 渲染 | （规划中）flutter_cube / flutter_gl | PRD 指定，尚未引入 |
| 全局快捷键 | （规划中）hotkey_manager | PRD 指定，尚未引入 |
| 构建系统 | CMake + Ninja | Windows 桌面端原生编译 |
| 编译器 | MSVC 19.44 (VS Build Tools) | 路径硬编码在 CMakeLists.txt 中 |

**当前实际已引入的依赖**（见 `pprogram/pubspec.yaml`）：
- `flutter` (SDK)
- `cupertino_icons: ^1.0.8`
- `flutter_lints: ^6.0.0` (dev)

---

## 3. 项目结构

```
D:\Point\
├── pprogram/                   # 主 Flutter 应用
│   ├── lib/
│   │   └── main.dart           # 入口文件（当前为默认计数器模板）
│   ├── test/
│   │   └── widget_test.dart    # 默认 widget 测试
│   ├── windows/                # Windows 平台原生代码
│   │   ├── CMakeLists.txt      # 项目级 CMake（含硬编码 MSVC 路径）
│   │   └── runner/
│   │       ├── CMakeLists.txt  # 可执行文件构建配置
│   │       ├── main.cpp        # Win32 入口
│   │       ├── flutter_window.cpp/.h
│   │       ├── win32_window.cpp/.h
│   │       ├── utils.cpp/.h
│   │       ├── Runner.rc
│   │       └── runner.exe.manifest
│   ├── android/                # Android 平台（未启用）
│   ├── ios/                    # iOS 平台（未启用）
│   ├── linux/                  # Linux 平台（未启用）
│   ├── macos/                  # macOS 平台（未启用）
│   ├── web/                    # Web 平台（未启用）
│   ├── pubspec.yaml            # Flutter 包配置
│   ├── analysis_options.yaml   # Dart 静态分析配置
│   └── diag/                   # 诊断/测试用最小工程
│       ├── test.cpp
│       └── test.vcxproj
├── testcmake/                  # 最小 CMake 测试工程
│   ├── CMakeLists.txt
│   └── test.cpp
├── tools/
│   ├── flutter.bat             # Flutter 命令封装
│   └── flutter.ps1             # Flutter 命令封装（PowerShell）
├── SwitchPoint_PRD_v1.0.md     # 产品需求文档（中文）
├── build_and_run.bat           # 完整构建并运行（Debug，手动复制引擎产物 + CMake + Ninja + bundle）
├── build_and_run_debug.bat     # 同上，但带详细回显
├── build_flutter.bat           # 使用 flutter CLI 构建（`flutter build windows`）
├── build_flutter_ninja.bat     # 手动复制产物 + CMake + Ninja（不运行）
├── build_with_ninja.bat        # 纯 CMake + Ninja（不手动复制 Flutter 产物）
├── run_flutter.bat             # `flutter run -d windows`
├── run_flutter_final.bat       # 同上
├── run_flutter_vsdev.bat       # `flutter clean` + `flutter run -d windows`
├── run_app.bat                 # 直接运行已构建的可执行文件
├── check_env.bat               # 导出 LIB/INCLUDE/PATH 到 env.txt
├── check_vc.bat                # 检查 MSVC 环境变量
├── check_lib.bat               # 检查 LIB 路径
├── fix_winsdk_registry.reg     # Windows SDK 注册表修复
├── test.cpp / test.exe         # 本地最小 C++ 测试文件
├── testdiag.cpp / testdiag.exe # 诊断测试文件
└── AGENTS.md                   # 本文件
```

---

## 4. 开发环境

### 4.1 必备工具与路径

本项目在 Windows 上开发，所有路径均为**绝对路径且硬编码**在脚本与 CMake 配置中：

| 工具 | 路径 | 说明 |
|------|------|------|
| Flutter SDK | `D:\Android\flutter\` | 引擎产物从这里复制 |
| VS Build Tools | `D:\Android\VSBuildTools\` | MSVC 14.44.35207 |
| Windows SDK | `C:\Program Files (x86)\Windows Kits\10\` | 版本 `10.0.26100.0` |
| Android Studio | `D:\Android\Android Studio\` | IDE 与 bundled JDK 所在位置 |
| JDK | `D:\Android\Android Studio\jbr\` | Flutter config 中 `jdk-dir` 指向此处 |
| vcvarsall.bat | `D:\Android\VSBuildTools\VC\Auxiliary\Build\vcvarsall.bat` | 所有 `.bat` 都先 call 它 |

> **注意**：Flutter SDK、VS Build Tools、Android Studio 均安装在 `D:\Android\` 这一**自定义非默认路径**下（默认通常在 `C:\` 或用户目录下）。后续若迁移或重新安装工具链，需同步更新所有 `.bat` 脚本、`CMakeLists.txt` 以及 Flutter config（`flutter config --android-studio-dir`、`flutter config --jdk-dir`）。|

### 4.2 环境初始化

在 PowerShell/CMD 中执行任何构建前，必须先加载 MSVC 环境：

```batch
call "D:\Android\VSBuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
```

所有根目录的 `.bat` 脚本已自动包含此步骤。

### 4.3 已知环境限制

- `flutter build windows` 在环境中常因 `generated_config.cmake` 缺失而失败，因此维护了一套**手动复制 Flutter 引擎产物**的脚本（`build_and_run.bat`、`build_and_run_debug.bat`、`build_flutter_ninja.bat`）。
- CMakeLists.txt 中硬编码了 MSVC 与 Windows SDK 路径，若升级工具链必须同步修改 `pprogram/windows/CMakeLists.txt`。

---

## 5. 构建与运行命令

### 5.1 推荐：完整构建并运行（手动复制产物 + Ninja）

```batch
D:\Point\build_and_run.bat
```

流程：
1. 加载 MSVC 环境
2. 删除旧 `build\windows`
3. 创建 `windows\flutter\ephemeral` 并手动复制 `flutter_windows.dll`、头文件、`cpp_client_wrapper`
4. `cmake -S windows -B build\windows\x64 -G Ninja`
5. `ninja -C build\windows\x64`
6. 复制 `flutter_windows.dll`、`icudtl.dat` 到 runner 目录
7. `flutter build bundle --target-platform=windows-x64`
8. 复制 flutter_assets
9. 运行 `build\windows\x64\runner\pprogram.exe`

### 5.2 使用 Flutter CLI（若环境正常）

```batch
cd D:\Point\pprogram
flutter run -d windows
```

或生产构建：

```batch
flutter build windows
```

### 5.3 仅原生 C++ 部分（不编译 Dart）

```batch
D:\Point\build_with_ninja.bat
```

### 5.4 最小测试工程

用于验证 CMake/MSVC 环境：

```batch
cd D:\Point\testcmake
cmake -S . -B build -G Ninja
cmake --build build
```

---

## 6. 测试

### 6.1 Dart/Flutter 测试

```batch
cd D:\Point\pprogram
flutter test
```

当前仅有 `test/widget_test.dart` 一个默认计数器冒烟测试。

### 6.2 原生 C++ 诊断

- `testcmake/test.cpp` — 验证 CMake + Ninja + MSVC 是否能正常编译出可执行文件。
- `pprogram/diag/test.cpp` — 同上的 Visual Studio 工程版本。
- 根目录 `test.cpp`、`testdiag.cpp` — 环境验证用最小 C++ 文件。

---

## 7. 代码风格规范

### 7.1 Dart

- 使用 `package:flutter_lints/flutter.yaml` 作为基础规则集。
- 如需关闭某条规则，在 `analysis_options.yaml` 中修改，或在文件内使用 `// ignore_for_file: name_of_lint`。
- 当前未启用 `avoid_print` 强制规则（默认关闭），MVP 阶段允许 `print` 用于调试，但建议逐步迁移到 `logger`。

### 7.2 C++（Windows Runner）

- 使用 `cxx_std_17`。
- 编译选项： `/W4 /WX /wd4100 /EHsc`
- 异常关闭：`_HAS_EXCEPTIONS=0`
- 禁用 Windows 宏与 STL 冲突：`NOMINMAX`
- 新增源文件必须同步添加到 `windows/runner/CMakeLists.txt` 的 `add_executable` 中。

### 7.3 语言与注释

- **产品文档、PRD、需求描述**：中文。
- **代码注释**：遵循 Flutter/Dart 官方风格，使用英文。若添加中文业务注释，保持清晰即可。
- **变量与类命名**：按 Flutter/Dart 社区规范（lowerCamelCase 变量、UpperCamelCase 类名、lower_snake_case 文件名）。

---

## 8. 安全与隐私

根据 PRD 要求，未来需遵循以下安全策略（当前尚未实现，但架构设计时必须预留）：

- **本地存储加密**: Hive 数据库使用 AES-256 加密密钥（密钥派生自设备指纹，不上传）。
- **崩溃日志**: 本地保存最近 30 天崩溃日志到 `logs/crash/` 目录，日志中不得包含用户任务内容等隐私数据。
- **数据备份**: 每天首次启动时自动导出 JSON 到 `backups/` 目录，保留最近 7 份；设置页提供手动备份/恢复入口。
- **零联网**: MVP 阶段完全不联网，无账号系统、无云端同步。

---

## 9. 开发注意事项

1. **不要假设业务逻辑已存在**：当前 `lib/main.dart` 仍是计数器 Demo。所有业务（TimerService、DiceService、TaskService、PointService 等）均需从零实现。
2. **修改 CMake 时谨慎**：`windows/CMakeLists.txt` 中硬编码了 MSVC 与 SDK 路径，若误改会导致整个 Windows 构建失败。
3. **新增依赖必须同步 `pubspec.yaml`**：PRD 中规划了 riverpod、hive、window_manager、system_tray 等包，实际引入时请在 `dependencies` 中显式声明并锁定合适版本。
4. **Windows 托盘与置顶弹窗需要原生插件**：这些功能依赖 platform channel 或第三方插件，测试时必须在 Windows 桌面端真机/实体机上运行，而非 Web 模拟器。
5. **路径敏感**：所有 `.bat` 脚本和 `CMakeLists.txt` 均使用 Windows 绝对路径，不要跨平台直接复用这些脚本。

---

*本文档基于项目实际文件与 `SwitchPoint_PRD_v1.0.md` 编写。若项目结构、依赖或构建流程发生变化，请同步更新本文件。*
