import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/google_maps_directions_button.dart';
import 'package:materyalph/design_system/theme.dart';

void main() {
  testWidgets('a failed launch keeps the button available for retry', (
    tester,
  ) async {
    var attempts = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: Scaffold(
          body: GoogleMapsDirectionsButton(
            destination: '14.61,120.99',
            openLink: (_) async {
              attempts++;
              if (attempts == 1) throw Exception('Launch failed');
            },
          ),
        ),
      ),
    );
    final button = find.text('Directions in Google Maps');
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(
      find.text('Google Maps could not open. Please try again.'),
      findsOneWidget,
    );
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(attempts, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the labelled control fits a narrow screen with large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: GoogleMapsDirectionsButton(
                destination: '14.61,120.99',
                openLink: (_) async {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(OutlinedButton)).height,
      greaterThanOrEqualTo(44),
    );
    expect(find.text('Directions in Google Maps'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
