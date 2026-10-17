import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/screens/splash_screen.dart';

double _wordmarkOpacity(WidgetTester tester) => tester
    .widget<FadeTransition>(
      find
          .ancestor(
            of: find.text('MateryalPH', findRichText: true),
            matching: find.byType(FadeTransition),
          )
          .first,
    )
    .opacity
    .value;

void main() {
  testWidgets('keeps the mark centred where the native splash drew it', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
    expect(_wordmarkOpacity(tester), 0);
    // The progress indicator is indeterminate, so pump a fixed time instead of settling.
    await tester.pump(const Duration(milliseconds: 600));

    final markRect = tester.getRect(find.byType(Image));
    expect(markRect.size, SplashScreen.markSize);
    expect(markRect.center, tester.getCenter(find.byType(Scaffold)));
    expect(_wordmarkOpacity(tester), 1);
    expect(find.bySemanticsLabel('MateryalPH'), findsOneWidget);
    expect(find.bySemanticsLabel('Opening your account'), findsOneWidget);
  });

  testWidgets('shows the final state immediately under Reduce Motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        ),
        home: const SplashScreen(),
      ),
    );

    expect(_wordmarkOpacity(tester), 1);
  });
}
