// App state provider using InheritedWidget

import 'package:flutter/material.dart';
import 'app_state.dart';

class AppStateProvider extends InheritedWidget {
  final AppState appState;

  const AppStateProvider({
    super.key,
    required this.appState,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'No AppStateProvider found in context');
    return provider!.appState;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) {
    return false;
  }
}
