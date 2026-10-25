import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/core/foreground_refresh.dart';

class _RefreshProbe extends StatefulWidget {
  const _RefreshProbe({required this.refresh});
  final Future<bool> Function() refresh;
  @override
  State<_RefreshProbe> createState() => _RefreshProbeState();
}

class _RefreshProbeState extends State<_RefreshProbe>
    with ForegroundRefresh<_RefreshProbe> {
  @override
  Future<bool> refreshInForeground() => widget.refresh();
  @override
  Widget build(BuildContext context) => const SizedBox();
}

void main() {
  testWidgets(
    'refreshes on entry, every five seconds and when returning to a tab',
    (tester) async {
      var calls = 0;
      Future<bool> refresh() async {
        calls++;
        return true;
      }

      Widget app(bool active) => MaterialApp(
        home: TickerMode(
          enabled: active,
          child: _RefreshProbe(refresh: refresh),
        ),
      );
      await tester.pumpWidget(app(true));
      await tester.pump();
      expect(calls, 1);
      await tester.pump(const Duration(seconds: 5));
      expect(calls, 2);
      await tester.pumpWidget(app(false));
      await tester.pump(const Duration(minutes: 1));
      expect(calls, 2);
      await tester.pumpWidget(app(true));
      await tester.pump();
      expect(calls, 3);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('pauses while backgrounded and refreshes immediately on resume', (
    tester,
  ) async {
    var calls = 0;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(
      MaterialApp(
        home: _RefreshProbe(
          refresh: () async {
            calls++;
            return true;
          },
        ),
      ),
    );
    await tester.pump();
    expect(calls, 1);
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pump(const Duration(minutes: 1));
    expect(calls, 1);
    for (final state in [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pump();
    expect(calls, 2);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('covered routes pause and returning triggers revalidation', (
    tester,
  ) async {
    var calls = 0;
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        home: _RefreshProbe(
          refresh: () async {
            calls++;
            return true;
          },
        ),
      ),
    );
    await tester.pump();
    navigator.currentState!.push<void>(
      MaterialPageRoute(builder: (_) => const SizedBox()),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 20));
    expect(calls, 1);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(calls, 2);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('slow requests never overlap, and failures back off', (
    tester,
  ) async {
    var calls = 0;
    var pending = Completer<bool>();
    await tester.pumpWidget(
      MaterialApp(
        home: _RefreshProbe(
          refresh: () {
            calls++;
            return pending.future;
          },
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 30));
    expect(calls, 1);
    pending.complete(false);
    await tester.pump();
    pending = Completer<bool>();
    await tester.pump(const Duration(seconds: 9));
    expect(calls, 1);
    await tester.pump(const Duration(seconds: 1));
    expect(calls, 2);
    pending.complete(false);
    await tester.pump();
    pending = Completer<bool>();
    await tester.pump(const Duration(seconds: 19));
    expect(calls, 2);
    await tester.pump(const Duration(seconds: 1));
    expect(calls, 3);
    pending.complete(true);
    await tester.pump();
    pending = Completer<bool>();
    await tester.pump(const Duration(seconds: 5));
    expect(calls, 4);
    await tester.pumpWidget(const SizedBox());
    pending.complete(true);
    await tester.pump(const Duration(minutes: 1));
    expect(calls, 4);
  });
}
