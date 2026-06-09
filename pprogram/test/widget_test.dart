import 'package:flutter_test/flutter_test.dart';
import 'package:pprogram/models/app_state.dart';
import 'package:pprogram/models/app_state_provider.dart';
import 'package:pprogram/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      AppStateProvider(
        appState: appState,
        child: const SwitchPointApp(),
      ),
    );

    expect(find.text('切点'), findsOneWidget);
    expect(find.text('SwitchPoint'), findsOneWidget);
  });
}
