// Settings page for the SwitchPoint app

import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/app_state_provider.dart';
import '../models/settings.dart';
import '../models/dice.dart';
import '../services/timer_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppState _appState;
  late TimerService _timerService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = AppStateProvider.of(context);
    _timerService = TimerService(_appState);
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
              _buildHeader(),
              const SizedBox(height: 24),
              _buildStatusCard(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Timer Settings'),
                      const SizedBox(height: 16),
                      _buildSliderSetting(
                        label: 'Work Duration (T1)',
                        value: _appState.settings.workDurationMinutes.toDouble(),
                        min: 10,
                        max: 120,
                        unit: 'min',
                        onChanged: (value) {
                          _appState.updateSettings(
                            _appState.settings.copyWith(
                              workDurationMinutes: value.round(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSliderSetting(
                        label: 'Rest Duration (T2)',
                        value: _appState.settings.restDurationMinutes.toDouble(),
                        min: 1,
                        max: 60,
                        unit: 'min',
                        onChanged: (value) {
                          _appState.updateSettings(
                            _appState.settings.copyWith(
                              restDurationMinutes: value.round(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSliderSetting(
                        label: 'Force Wait Duration',
                        value: _appState.settings.forceWaitSeconds.toDouble(),
                        min: 5,
                        max: 15,
                        unit: 'sec',
                        onChanged: (value) {
                          _appState.updateSettings(
                            _appState.settings.copyWith(
                              forceWaitSeconds: value.round(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Default Dice'),
                      const SizedBox(height: 16),
                      _buildDiceSelector(),
                      const SizedBox(height: 32),
                      _buildSectionTitle('Do Not Disturb'),
                      const SizedBox(height: 16),
                      _buildDoNotDisturbSettings(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2E),
          ),
        ),
        _buildModeToggleButton(),
      ],
    );
  }

  Widget _buildModeToggleButton() {
    final isRunning = _appState.currentMode == AppMode.working ||
        _appState.currentMode == AppMode.resting ||
        _appState.currentMode == AppMode.tasking;

    return ElevatedButton.icon(
      onPressed: () {
        if (isRunning) {
          _timerService.stopTimer();
        } else {
          _timerService.startWorkTimer();
        }
      },
      icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
      label: Text(isRunning ? 'Stop' : 'Start SwitchPoint'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isRunning ? Colors.red : const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _appState.currentMode.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _appState.currentMode.icon,
              color: _appState.currentMode.color,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _appState.currentMode.displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2E),
                  ),
                ),
                const SizedBox(height: 4),
                if (_appState.remainingSeconds > 0)
                  Text(
                    'Remaining: ${_appState.remainingTimeText}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  )
                else
                  const Text(
                    'Waiting to start',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E1E2E),
      ),
    );
  }

  Widget _buildSliderSetting({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${value.round()} $unit',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).round(),
            activeColor: const Color(0xFF6366F1),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDiceSelector() {
    return Wrap(
      spacing: 12,
      children: DiceType.values.map((dice) {
        final isSelected = _appState.settings.defaultDice == dice;
        return ChoiceChip(
          label: Text('${dice.displayName} (d${dice.faces})'),
          selected: isSelected,
          selectedColor: const Color(0xFF6366F1),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          onSelected: (selected) {
            if (selected) {
              _appState.updateSettings(
                _appState.settings.copyWith(defaultDice: dice),
              );
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildDoNotDisturbSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Enable Do Not Disturb'),
            subtitle: const Text('No interruptions during set hours'),
            value: _appState.settings.doNotDisturbEnabled,
            activeColor: const Color(0xFF6366F1),
            onChanged: (value) {
              _appState.updateSettings(
                _appState.settings.copyWith(doNotDisturbEnabled: value),
              );
            },
          ),
          if (_appState.settings.doNotDisturbEnabled) ...[
            const Divider(),
            ListTile(
              title: const Text('Start Time'),
              trailing: Text(
                _appState.settings.doNotDisturbStart?.toString() ?? '22:00',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
            ListTile(
              title: const Text('End Time'),
              trailing: Text(
                _appState.settings.doNotDisturbEnd?.toString() ?? '08:00',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
