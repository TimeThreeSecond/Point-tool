// Dice game page for the SwitchPoint app

import 'dart:math';
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/app_state_provider.dart';
import '../models/dice.dart';
import '../services/dice_service.dart';

class DiceGamePage extends StatefulWidget {
  const DiceGamePage({super.key});

  @override
  State<DiceGamePage> createState() => _DiceGamePageState();
}

class _DiceGamePageState extends State<DiceGamePage>
    with TickerProviderStateMixin {
  late AppState _appState;
  final DiceService _diceService = DiceService();
  
  DiceType _selectedDice = DiceType.d6;
  DiceRoll? _lastRoll;
  bool _isRolling = false;
  
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = AppStateProvider.of(context);
    _selectedDice = _appState.settings.defaultDice;
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _rollDice() async {
    if (_isRolling) return;

    setState(() {
      _isRolling = true;
      _lastRoll = null;
    });

    // Animate
    _rotationController.repeat();
    await Future.delayed(const Duration(milliseconds: 800));
    _rotationController.stop();

    // Get result
    final result = _diceService.roll(_selectedDice);

    setState(() {
      _lastRoll = result;
      _isRolling = false;
    });

    // Update stats
    _appState.incrementRolls();
    if (result.isReward) {
      _appState.addPoints(result.pointsEarned);
    }
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
                'Dice Game',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total Points: ${_appState.totalPoints} | Total Rolls: ${_appState.totalRolls}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              // Dice selector
              _buildDiceSelector(),
              const SizedBox(height: 32),
              // Dice display
              Expanded(
                child: Center(
                  child: _buildDiceDisplay(),
                ),
              ),
              // Roll button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isRolling ? null : _rollDice,
                  icon: _isRolling
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.casino),
                  label: Text(_isRolling ? 'Rolling...' : 'Roll Dice'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (_lastRoll != null) ...[
                const SizedBox(height: 16),
                _buildResultCard(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDiceSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Dice',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: DiceType.values.map((dice) {
              final isSelected = _selectedDice == dice;
              return ChoiceChip(
                label: Text('${dice.displayName}\nd${dice.faces}'),
                selected: isSelected,
                selectedColor: const Color(0xFF6366F1),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedDice = dice;
                    });
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDiceDisplay() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: _lastRoll != null
                  ? Text(
                      '${_lastRoll!.rolledValue}',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    )
                  : const Icon(
                      Icons.casino,
                      size: 100,
                      color: Color(0xFF6366F1),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultCard() {
    final isReward = _lastRoll!.isReward;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isReward ? Colors.amber[50] : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isReward ? Colors.amber[200]! : Colors.blue[200]!,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isReward ? Icons.emoji_events : Icons.info,
                color: isReward ? Colors.amber : Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                isReward ? 'Reward!' : 'No Reward',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isReward ? Colors.amber[700] : Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isReward)
            Text(
              '+${_lastRoll!.pointsEarned} Points',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6366F1),
              ),
            ),
          Text(
            'Probability: ${(_selectedDice.rewardProbability * 100).toStringAsFixed(1)}%',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
