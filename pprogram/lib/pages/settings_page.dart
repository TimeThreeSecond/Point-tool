// Settings page for the SwitchPoint app

import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/app_state_provider.dart';
import '../i18n/strings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late AppState _appState;
  final _keywordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = AppStateProvider.of(context);
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
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
              _buildDetectionStatus(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEntertainmentAppList(),
                      const SizedBox(height: 20),
                      _buildDetectionSettings(),
                      const SizedBox(height: 20),
                      _buildPopupSettings(),
                      const SizedBox(height: 20),
                      _buildDoNotDisturbSettings(),
                      const SizedBox(height: 20),
                      _buildLanguageSetting(),
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
        Text(tr.settings, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2E))),
        Icon(Icons.fiber_manual_record, color: _appState.detectionActive ? Colors.green : Colors.grey, size: 16),
      ],
    );
  }

  Widget _buildDetectionStatus() {
    final ratio = _appState.entertainmentRatio;
    final title = _appState.currentForegroundTitle ?? tr.waiting;
    final process = _appState.currentForegroundProcess ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.liveDetection, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildInfoRow(tr.currentWindow, title),
          if (process.isNotEmpty) _buildInfoRow(tr.process, process),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${tr.entertainmentRatio}: ', style: const TextStyle(fontSize: 14)),
              Expanded(
                child: LinearProgressIndicator(
                  value: ratio,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(
                    ratio > _appState.settings.triggerThreshold ? Colors.red : const Color(0xFF6366F1),
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(ratio * 100).toStringAsFixed(0)}${tr.percent}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ratio > _appState.settings.triggerThreshold ? Colors.red : const Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          if (_appState.detectionActive) ...[
            const SizedBox(height: 8),
            Text(
              tr.windowAndThresholdSummary
                  .format({'w': '${_appState.settings.detectionWindowMinutes}', 't': '${(_appState.settings.triggerThreshold * 100).toStringAsFixed(0)}', 'b': '${_appState.todayBreaks}'}),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildEntertainmentAppList() {
    final keywords = _appState.settings.entertainmentKeywords;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.entertainmentApps, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(tr.entertainmentAppsHint, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...keywords.map((kw) => Chip(
                    label: Text(kw),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      final updated = List<String>.from(keywords)..remove(kw);
                      _appState.updateSettings(
                        _appState.settings.copyWith(entertainmentKeywords: updated),
                      );
                    },
                  )),
              ActionChip(
                avatar: const Icon(Icons.add, size: 16),
                label: Text(tr.add),
                onPressed: _showAddKeywordDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddKeywordDialog() {
    _keywordController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.addKeyword),
        content: TextField(
          controller: _keywordController,
          decoration: InputDecoration(hintText: tr.keywordHint, border: const OutlineInputBorder()),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(tr.cancel)),
          ElevatedButton(
            onPressed: () {
              final text = _keywordController.text.trim();
              if (text.isNotEmpty) {
                final updated = List<String>.from(_appState.settings.entertainmentKeywords)..add(text);
                _appState.updateSettings(_appState.settings.copyWith(entertainmentKeywords: updated));
              }
              Navigator.pop(context);
            },
            child: Text(tr.add),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.detectionParams, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSliderSetting(
            label: tr.detectionWindow,
            value: _appState.settings.detectionWindowMinutes.toDouble(),
            min: 5,
            max: 120,
            step: 5,
            unit: tr.minutes,
            onChanged: (v) => _appState.updateSettings(
              _appState.settings.copyWith(detectionWindowMinutes: v.round()),
            ),
          ),
          const SizedBox(height: 12),
          _buildSliderSetting(
            label: tr.triggerThreshold,
            value: _appState.settings.triggerThreshold * 100,
            min: 30,
            max: 100,
            step: 5,
            unit: tr.percent,
            onChanged: (v) => _appState.updateSettings(
              _appState.settings.copyWith(triggerThreshold: v / 100),
            ),
          ),
          const SizedBox(height: 12),
          _buildSliderSetting(
            label: tr.minEntertainment,
            value: _appState.settings.minEntertainmentMinutes.toDouble(),
            min: 1,
            max: 30,
            step: 1,
            unit: tr.minutes,
            onChanged: (v) => _appState.updateSettings(
              _appState.settings.copyWith(minEntertainmentMinutes: v.round()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.popupSettings, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSliderSetting(
            label: tr.forceWait,
            value: _appState.settings.forceWaitSeconds.toDouble(),
            min: 3,
            max: 20,
            step: 1,
            unit: tr.seconds,
            onChanged: (v) => _appState.updateSettings(
              _appState.settings.copyWith(forceWaitSeconds: v.round()),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(tr.showDice),
            subtitle: Text(tr.showDiceHint),
            value: _appState.settings.showDice,
            activeColor: const Color(0xFF6366F1),
            contentPadding: EdgeInsets.zero,
            onChanged: (v) => _appState.updateSettings(
              _appState.settings.copyWith(showDice: v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoNotDisturbSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.doNotDisturb, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(tr.enableDnd),
            subtitle: Text(tr.dndHint),
            value: _appState.settings.doNotDisturbEnabled,
            activeColor: const Color(0xFF6366F1),
            contentPadding: EdgeInsets.zero,
            onChanged: (v) => _appState.updateSettings(
              _appState.settings.copyWith(doNotDisturbEnabled: v),
            ),
          ),
          if (_appState.settings.doNotDisturbEnabled) ...[
            const Divider(),
            ListTile(
              title: Text(tr.startTime),
              trailing: Text(
                _appState.settings.doNotDisturbStart?.toString() ?? '22:00',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              title: Text(tr.endTime),
              trailing: Text(
                _appState.settings.doNotDisturbEnd?.toString() ?? '08:00',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageSetting() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(tr.language, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextButton.icon(
            onPressed: () => _appState.toggleLanguage(),
            icon: const Icon(Icons.translate, size: 20),
            label: Text(
              tr.langName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting({
    required String label,
    required double value,
    required double min,
    required double max,
    required double step,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Text(
              '${value.round()}$unit',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) / step).round(),
          activeColor: const Color(0xFF6366F1),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
