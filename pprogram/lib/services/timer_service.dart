// Timer service for the SwitchPoint app

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_state.dart';

class TimerService {
  Timer? _timer;
  final AppState appState;

  TimerService(this.appState);

  void startWorkTimer() {
    _timer?.cancel();
    appState.setMode(AppMode.working);
    appState.setRemainingSeconds(appState.settings.workDurationMinutes * 60);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (appState.remainingSeconds > 0) {
        appState.setRemainingSeconds(appState.remainingSeconds - 1);
      } else {
        _onWorkTimerComplete();
      }
    });
  }

  void startRestTimer() {
    _timer?.cancel();
    appState.setMode(AppMode.resting);
    appState.setRemainingSeconds(appState.settings.restDurationMinutes * 60);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (appState.remainingSeconds > 0) {
        appState.setRemainingSeconds(appState.remainingSeconds - 1);
      } else {
        _onRestTimerComplete();
      }
    });
  }

  void startBreakCountdown() {
    appState.setBreakCountdown(appState.settings.forceWaitSeconds);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (appState.breakCountdownSeconds > 0) {
        appState.setBreakCountdown(appState.breakCountdownSeconds - 1);
      } else {
        timer.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    appState.setMode(AppMode.idle);
    appState.setRemainingSeconds(0);
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void resumeTimer() {
    if (appState.currentMode == AppMode.working) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (appState.remainingSeconds > 0) {
          appState.setRemainingSeconds(appState.remainingSeconds - 1);
        } else {
          _onWorkTimerComplete();
        }
      });
    } else if (appState.currentMode == AppMode.resting) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (appState.remainingSeconds > 0) {
          appState.setRemainingSeconds(appState.remainingSeconds - 1);
        } else {
          _onRestTimerComplete();
        }
      });
    }
  }

  void _onWorkTimerComplete() {
    _timer?.cancel();
    appState.setMode(AppMode.breaking);
  }

  void _onRestTimerComplete() {
    _timer?.cancel();
    startWorkTimer();
  }

  void dispose() {
    _timer?.cancel();
  }
}
