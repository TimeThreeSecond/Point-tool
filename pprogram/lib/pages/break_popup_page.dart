// Break popup page for demonstration

import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/app_state_provider.dart';
import '../models/dice.dart';
import '../services/timer_service.dart';
import '../services/dice_service.dart';

class BreakPopupPage extends StatefulWidget {
  const BreakPopupPage({super.key});

  @override
  State<BreakPopupPage> createState() => _BreakPopupPageState();
}

class _BreakPopupPageState extends State<BreakPopupPage> {
  late AppState _appState;
  late TimerService _timerService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = AppStateProvider.of(context);
    _timerService = TimerService(_appState);
  }

  void _showBreakPopup() {
    _appState.setMode(AppMode.breaking);
    _appState.setCurrentBreak(dice: _appState.settings.defaultDice);
    _timerService.startBreakCountdown();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BreakPopupDialog(
        appState: _appState,
        timerService: _timerService,
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
              const Text(
                'Break Popup Demo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2E),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'This page demonstrates the break interruption popup that appears when the work timer completes.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _showBreakPopup,
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('Simulate Break Popup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Popup Features:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFeatureItem('Always on top window'),
              _buildFeatureItem('Fixed position (top-right of primary monitor)'),
              _buildFeatureItem('Force wait countdown (5-15 seconds)'),
              _buildFeatureItem('3D dice animation'),
              _buildFeatureItem('Cannot be closed via Alt+F4'),
              _buildFeatureItem('Only closable via in-app buttons'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF6366F1), size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class BreakPopupDialog extends StatefulWidget {
  final AppState appState;
  final TimerService timerService;

  const BreakPopupDialog({
    super.key,
    required this.appState,
    required this.timerService,
  });

  @override
  State<BreakPopupDialog> createState() => _BreakPopupDialogState();
}

class _BreakPopupDialogState extends State<BreakPopupDialog> {
  bool _hasRolled = false;
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 360,
        height: 480,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF6366F1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'SwitchPoint Time!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _showResult ? _buildResultView() : _buildDiceView(),
              ),
            ),
            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (!_showResult) ...[
                    // Countdown progress
                    LinearProgressIndicator(
                      value: widget.appState.breakCountdownSeconds / 
                          widget.appState.settings.forceWaitSeconds,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF6366F1)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Wait ${widget.appState.breakCountdownSeconds} seconds...',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.appState.breakCountdownSeconds == 0 || _showResult
                              ? () {
                                  widget.timerService.stopTimer();
                                  widget.appState.clearCurrentBreak();
                                  Navigator.of(context).pop();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Continue Working'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _showResult ? null : _rollDice,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Roll Dice'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiceView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated dice
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Icon(
              Icons.casino,
              size: 80,
              color: Color(0xFF6366F1),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Current Dice: ${widget.appState.settings.defaultDice.displayName}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          'd${widget.appState.settings.defaultDice.faces}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6366F1),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    final isReward = widget.appState.currentIsReward ?? false;
    final rolledValue = widget.appState.currentRolledValue ?? 0;
    final points = isReward ? (widget.appState.currentBreakDice?.rewardPoints ?? 0) : 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isReward ? Icons.emoji_events : Icons.flash_on,
          size: 60,
          color: isReward ? Colors.amber : Colors.orange,
        ),
        const SizedBox(height: 16),
        Text(
          isReward ? 'Congratulations!' : 'Fate has chosen you',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isReward ? Colors.amber[700] : Colors.orange[700],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rolled: $rolledValue / ${widget.appState.currentBreakDice?.faces ?? 0}',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
        if (isReward) ...[
          const SizedBox(height: 16),
          Text(
            '+$points Points',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6366F1),
            ),
          ),
        ] else ...[
          const SizedBox(height: 16),
          if (widget.appState.currentTask != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    widget.appState.currentTask!.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.appState.currentTask!.durationMinutes} min',
                    style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  void _rollDice() {
    final diceService = DiceService();
    final result = diceService.roll(widget.appState.settings.defaultDice);
    
    widget.appState.setCurrentBreak(
      dice: widget.appState.settings.defaultDice,
      rolledValue: result.rolledValue,
      isReward: result.isReward,
    );

    if (!result.isReward) {
      final task = widget.appState.drawRandomTask();
      widget.appState.setCurrentBreak(
        dice: widget.appState.settings.defaultDice,
        rolledValue: result.rolledValue,
        isReward: false,
        task: task,
      );
    }

    widget.appState.incrementRolls();
    if (result.isReward) {
      widget.appState.addPoints(result.pointsEarned);
    }

    setState(() {
      _hasRolled = true;
      _showResult = true;
    });
  }
}
