// Break interruption popup for SwitchPoint

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../models/app_state.dart';
import '../models/app_state_provider.dart';
import '../i18n/strings.dart';

class BreakPopupPage extends StatefulWidget {
  const BreakPopupPage({super.key});

  @override
  State<BreakPopupPage> createState() => _BreakPopupPageState();
}

class _BreakPopupPageState extends State<BreakPopupPage>
    with SingleTickerProviderStateMixin {
  late AppState _appState;
  Timer? _countdownTimer;
  bool _diceRolled = false;
  int _diceValue = 0;
  bool _showTask = false;
  bool _taskCompleted = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = AppStateProvider.of(context);
    _startCountdown();
    _makeWindowAlwaysOnTop();
  }

  Future<void> _makeWindowAlwaysOnTop() async {
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setSize(const Size(400, 520));
    await windowManager.center();
    await windowManager.setPreventClose(true);
    await windowManager.show();
  }

  void _startCountdown() {
    _appState.setBreakCountdown(_appState.settings.forceWaitSeconds);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_appState.breakCountdownSeconds > 1) {
        _appState.setBreakCountdown(_appState.breakCountdownSeconds - 1);
      } else {
        _appState.setBreakCountdown(0);
        timer.cancel();
      }
    });
  }

  void _rollDice() {
    final rng = Random();
    setState(() {
      _diceValue = rng.nextInt(6) + 1;
      _diceRolled = true;
    });
  }

  void _showTaskPrompt() {
    _appState.assignRandomTask();
    setState(() => _showTask = true);
  }

  void _completeTask() {
    if (_appState.currentTask != null) {
      _appState.completeTask(_appState.currentTask!);
    }
    setState(() => _taskCompleted = true);
  }

  void _dismiss() async {
    _countdownTimer?.cancel();
    _appState.dismissBreak();
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setPreventClose(false);
    setState(() {
      _showTask = false;
      _taskCompleted = false;
      _diceRolled = false;
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, child) {
        if (!_appState.showBreakPopup) return const SizedBox.shrink();
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: 360,
              height: 480,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E1E2E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 32, offset: const Offset(0, 8))],
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildBody()),
                  _buildBottomButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF6366F1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          const Icon(Icons.adjust, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Text(
            _appState.breakCountdownSeconds > 0 ? tr.takeABreak : tr.timesUp,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Text(
              '${_appState.breakCountdownSeconds}s',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_taskCompleted) return _buildTaskCompleted();
    if (_showTask && _appState.currentTask != null) return _buildTaskView();
    return _buildDefaultView();
  }

  Widget _buildDefaultView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3), width: 3),
                  ),
                  child: Center(
                    child: Text(
                      '${_appState.breakCountdownSeconds}',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            _appState.breakCountdownSeconds > 0 ? tr.breathe : tr.youAreGood,
            style: TextStyle(fontSize: 16, color: _appState.breakCountdownSeconds > 0 ? Colors.grey : const Color(0xFF6366F1)),
          ),
          if (_appState.settings.showDice) ...[
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _rollDice,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: _diceRolled
                      ? Text('$_diceValue', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)))
                      : const Icon(Icons.casino, size: 40, color: Color(0xFF6366F1)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(_diceRolled ? tr.tapAgain : tr.tapDice, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskView() {
    final task = _appState.currentTask!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.assignment, size: 32, color: Colors.blue),
          ),
          const SizedBox(height: 20),
          Text(task.content, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            '${task.tag.displayName} · ${task.durationMinutes} ${tr.minutes}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Text(tr.honorPrompt, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _completeTask,
                icon: const Icon(Icons.check_circle, size: 20),
                label: Text(tr.done),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _dismiss,
                icon: const Icon(Icons.cancel, size: 20),
                label: Text(tr.notYet),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCompleted() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 64, color: Colors.green),
          const SizedBox(height: 16),
          Text(tr.wellDone, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 8),
          Text(tr.streakPlusOne, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    if (_taskCompleted || _showTask) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _appState.breakCountdownSeconds <= 0 ? _dismiss : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                    disabledBackgroundColor: Colors.grey[100],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _appState.breakCountdownSeconds > 0
                        ? tr.waitSeconds.format({'s': '${_appState.breakCountdownSeconds}'})
                        : tr.continueWorking,
                  ),
                ),
              ),
            ],
          ),
          if (_appState.breakCountdownSeconds <= 0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (_appState.settings.showDice)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _rollDice,
                      icon: const Icon(Icons.casino, size: 18),
                      label: Text(tr.rollDice),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                if (_appState.settings.showDice) const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showTaskPrompt,
                    icon: const Icon(Icons.assignment, size: 18),
                    label: Text(tr.honorTask),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
