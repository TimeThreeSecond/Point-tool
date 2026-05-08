# 切点 (SwitchPoint) — Agent 开发指南

> 面向 AI Coding Agent。阅读本文档前，请勿对项目做任何假设。

## 1. 项目状态

- **产品**: 切点 (SwitchPoint)，个人休闲效率工具，通过娱乐化打断机制帮助用户脱离短视频沉浸。
- **代号**: `pprogram`（Flutter 项目目录名）
- **当前阶段**: MVP UI框架已完成（W2）。`lib/main.dart` 已替换为带侧边栏导航的完整UI，包含：设置、打断弹窗、骰子游戏、任务管理、统计数据、历史记录。业务逻辑（TimerService、DiceService、TaskService）已实现基础版本，但系统托盘、置顶弹窗等原生功能**尚未接入**。
- **PRD**: `SwitchPoint_PRD_v1.0.md` 为开发唯一依据。

## 2. 技术栈与依赖

| 层级 | 技术 | 状态 |
|------|------|------|
| 框架 | Flutter | 已启用，仅 Windows 桌面端 |
| 语言 | Dart | SDK `^3.11.5` |
| 状态管理 | flutter_riverpod | **规划中，尚未引入**（当前使用ChangeNotifier） |
| 本地存储 | Hive | **规划中，尚未引入**（当前使用内存） |
| 窗口管理 | window_manager | **规划中，尚未引入** |
| 系统托盘 | system_tray | **规划中，尚未引入** |
| 构建系统 | CMake + Visual Studio 2022 | Flutter CLI原生构建 |
| 编译器 | MSVC 19.44 (VS Build Tools) | 路径硬编码在 CMakeLists.txt 中 |

**当前实际依赖**（`pprogram/pubspec.yaml`）：仅 `flutter` SDK、`cupertino_icons: ^1.0.8`、`flutter_lints: ^6.0.0` (dev)。

## 3. 开发环境（Windows 绝对路径，硬编码）

所有路径均为**绝对路径且硬编码**在脚本与 CMake 配置中，不可跨平台复用：

| 工具 | 路径 |
|------|------|
| Flutter SDK | `D:\Android\flutter\` |
| VS Build Tools | `D:\Android\VSBuildTools\` |
| Windows SDK | `C:\Program Files (x86)\Windows Kits\10\` (版本 `10.0.26100.0`) |
| JDK | `D:\Android\Android Studio\jbr\` |

> 若迁移或重装工具链，需同步更新所有 `.bat` 脚本、`pprogram/windows/CMakeLists.txt` 以及 Flutter config（`flutter config --android-studio-dir`、`flutter config --jdk-dir`）。

## 4. 构建与运行（重要修正）

### 4.1 推荐开发方式：Flutter CLI（已验证可用）

```batch
cd D:\Point\pprogram
flutter run -d windows
```

支持热重载（按 `r`）、断点调试、实时日志。**这是开发的标准方式**。

### 4.2 生产构建

```batch
cd D:\Point\pprogram
flutter build windows
```

产物在 `build\windows\x64\runner\Release\pprogram.exe`。**不要直接运行此exe进行开发**，它没有热重载，且构建问题会静默失败。

### 4.3 CMake生成器冲突的解决方法

如果切换过构建方式（如用过Ninja脚本后又用Flutter CLI），可能出现错误：

```
CMake Error: Error: generator : Visual Studio 17 2022
Does not match the generator used previously: Ninja
```

**解决**：删除缓存后重试

```batch
cd D:\Point\pprogram
rmdir /s /q build\windows
flutter run -d windows
```

### 4.4 备选方案：手动Ninja脚本（历史遗留）

若Flutter CLI出现特殊问题，可使用旧脚本：

```batch
D:\Point\build_and_run.bat
```

这会使用Ninja生成器手动构建。但**优先使用Flutter CLI**。

### 4.5 仅原生 C++ 部分（不编译 Dart）

```batch
D:\Point\build_with_ninja.bat
```

### 4.6 最小 CMake 测试工程

```batch
cd D:\Point\testcmake
cmake -S . -B build -G Ninja
cmake --build build
```

## 5. 测试

```batch
cd D:\Point\pprogram
flutter test
```

## 6. 代码风格

### 6.1 Dart
- 基础规则集：`package:flutter_lints/flutter.yaml`（`analysis_options.yaml` 中配置）。
- MVP 阶段允许 `print` 调试（`avoid_print` 未强制启用）。
- 命名：lowerCamelCase 变量、UpperCamelCase 类名、lower_snake_case 文件名。

### 6.2 C++（Windows Runner）
- 标准：`cxx_std_17`
- 编译选项：`/W4 /WX /wd4100 /EHsc`
- 定义：`_HAS_EXCEPTIONS=0`、`NOMINMAX`
- **新增源文件必须同步添加到 `windows/runner/CMakeLists.txt` 的 `add_executable` 中。**

### 6.3 语言与注释
- **产品文档、PRD、需求描述**：中文。
- **代码注释**：英文（Flutter/Dart 官方风格）。

## 7. 关键注意事项

1. **不要假设业务逻辑已存在**：当前UI框架已完成，但系统托盘、窗口置顶、全屏检测等原生功能**尚未实现**，需接入 `window_manager`、`system_tray` 等插件。
2. **修改 CMake 时谨慎**：`windows/CMakeLists.txt` 中硬编码了 MSVC 与 SDK 路径，若误改会导致整个 Windows 构建失败。
3. **新增依赖必须同步 `pubspec.yaml`**：PRD 中规划了 riverpod、hive、window_manager、system_tray 等包，实际引入时请在 `dependencies` 中显式声明并锁定合适版本。
4. **Windows 托盘与置顶弹窗需要原生插件**：这些功能依赖 platform channel 或第三方插件，测试时必须在 Windows 桌面端真机/实体机上运行，而非 Web 模拟器。
5. **路径敏感**：所有 `.bat` 脚本和 `CMakeLists.txt` 均使用 Windows 绝对路径，不要跨平台直接复用这些脚本。
6. **构建缓存问题**：如果构建失败提示生成器不匹配，删除 `build/windows` 目录即可解决。

---

*本文档基于项目实际文件与 `SwitchPoint_PRD_v1.0.md` 编写。若项目结构、依赖或构建流程发生变化，请同步更新本文件。*
