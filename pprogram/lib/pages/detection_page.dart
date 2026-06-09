// Real-time detection status page

import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/app_state_provider.dart';
import '../i18n/strings.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  late AppState _appState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = AppStateProvider.of(context);
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
              Text(tr.detection, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2E))),
              const SizedBox(height: 8),
              Text(tr.detectionSubtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 24),
              _buildInfoCard(
                tr.currentWindow,
                Icons.desktop_windows,
                _appState.currentForegroundTitle ?? tr.waiting,
                subtitle: _appState.currentForegroundProcess != null
                    ? '${tr.process}: ${_appState.currentForegroundProcess}'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildRatioCard(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatCard(tr.breaksToday, '${_appState.todayBreaks}', Icons.notifications_active, Colors.orange)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(tr.tasksDone, '${_appState.tasksCompleted}', Icons.check_circle, Colors.green)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(tr.dayStreak, '${_appState.currentStreakDays}', Icons.local_fire_department, Colors.red)),
                ],
              ),
              if (_appState.detectionActive) ...[
                const SizedBox(height: 24),
                Text(tr.detectionParams, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  '${tr.detectionWindow}: ${_appState.settings.detectionWindowMinutes}${tr.minutes} · '
                  '${tr.triggerThreshold}: ${(_appState.settings.triggerThreshold * 100).toStringAsFixed(0)}${tr.percent} · '
                  '${tr.minEntertainment}: ${_appState.settings.minEntertainmentMinutes}${tr.minutes}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  '${tr.entertainmentApps}: ${_appState.settings.entertainmentKeywords.join(", ")}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String title, IconData icon, String value, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF6366F1), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatioCard() {
    final ratio = _appState.entertainmentRatio;
    final isTriggered = ratio >= _appState.settings.triggerThreshold;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isTriggered
              ? [Colors.red[400]!, Colors.orange[400]!]
              : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.entertainmentRatio, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(ratio * 100).toStringAsFixed(1)}${tr.percent}',
                style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/ ${(_appState.settings.triggerThreshold * 100).toStringAsFixed(0)}${tr.percent}',
                  style: const TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio / 1.0,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isTriggered ? tr.triggered : tr.triggerHint.format({'m': '${_appState.settings.minEntertainmentMinutes}'}),
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
