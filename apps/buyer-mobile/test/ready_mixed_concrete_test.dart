import 'package:materyalph/design_system/components/procurement_components.dart';
import 'package:materyalph/features/item_procurement/delivery_widgets.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph/features/item_procurement/site_inspection_sheet.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ready-mixed concrete helpers', () {
    test('decimal quantities follow the sale unit step', () {
      expect(stepDecimals('1'), 0);
      expect(stepDecimals('0.001'), 3);
      expect(validDecimalQuantity('7.5', 3), isTrue);
      expect(validDecimalQuantity('7.5005', 3), isFalse);
      expect(validDecimalQuantity('0', 3), isFalse);
      expect(validDecimalQuantity('2.5', 0), isFalse);
    });

    test('line amounts round half-up to the centavo like the server', () {
      expect(lineAmountCentavos('7.5', 520000), 3900000);
      expect(lineAmountCentavos('0.333', 100), 33);
      expect(lineAmountCentavos('0.005', 100), 1);
      expect(lineAmountCentavos('3', 1800), 5400);
    });

    test('mixer trips read as full loads plus the remainder', () {
      const plan = MixerVolumePlanView(
        totalM3: 7.5,
        fullLoadM3: 6,
        fullTrips: 1,
        lastTripM3: 1.5,
      );
      expect(plan.tripLoads, '6 m³ + 1.5 m³');
      const even = MixerVolumePlanView(
        totalM3: 12,
        fullLoadM3: 6,
        fullTrips: 1,
        lastTripM3: 6,
      );
      expect(even.tripLoads, '2 × 6 m³');
      const option = DeliveryOptionView(
        vehicleName: 'Transit mixer',
        vehicles: 2,
        trips: 2,
        feeCentavos: 493600,
        vehicleType: 'CONCRETE_MIXER',
        mobilizationBasis: 'PER_TRUCK',
        mobilizationTotalCentavos: 300000,
        volumePlan: plan,
      );
      final line = deliveryOptionLine(option);
      expect(line, contains('2 mixer trucks'));
      expect(line, contains('6 m³ + 1.5 m³'));
      expect(line, contains('mobilization per truck'));
    });

    test('ordinary vehicles keep their existing wording', () {
      expect(
        deliveryOptionLine(
          const DeliveryOptionView(
            vehicleName: 'Box truck',
            vehicles: 1,
            trips: 1,
            feeCentavos: 60500,
          ),
        ),
        'Box truck · 1 vehicle(s) · 1 trip(s) · ₱605.00',
      );
    });
  });

  testWidgets(
    'decimal quantity field preserves invalid text for parent validation',
    (tester) async {
      final values = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DecimalQuantityField(
              label: 'Order volume (m³)',
              value: '',
              unitName: 'cubic meter',
              decimals: 3,
              onChanged: values.add,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), '7.5005');
      await tester.pump();
      expect(find.textContaining('up to 3 decimal places'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '7.5');
      await tester.pump();
      expect(values, ['7.5005', '7.5']);
    },
  );

  testWidgets('site inspection sheet sends the chosen site, date and notes', (
    tester,
  ) async {
    final sent = <Map<String, Object?>>[];
    String? popped;
    final site = SavedLocationView(
      id: 'site-1',
      label: 'Tower site',
      kind: 'PROJECT_SITE',
      isPrimary: true,
      formattedAddress: 'Aurora Blvd, Quezon City',
      point: const GeoPoint(14.6, 121),
      psgc: const PsgcSummary(resolution: 'UNRESOLVED'),
      lockVersion: 1,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () async {
                  popped = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => SiteInspectionSheet(
                      productName: 'Ready-mixed concrete',
                      storeName: 'Batching Plant',
                      locations: [site],
                      today: DateTime(2026, 10, 17),
                      submit:
                          ({
                            required locationId,
                            required preferredDate,
                            required key,
                            notes,
                          }) async {
                            sent.add({
                              'location': locationId,
                              'date': preferredDate,
                              'notes': notes,
                            });
                            return 'conversation-1';
                          },
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Request a free site inspection'), findsOneWidget);
    expect(find.textContaining('The inspection is free'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, 'Notes for the store (optional)'),
      'Slab is 12 m by 20 m.',
    );
    await tester.tap(find.text('Send request'));
    await tester.pumpAndSettle();
    expect(sent.single['location'], 'site-1');
    expect(sent.single['date'], DateTime(2026, 10, 18));
    expect(sent.single['notes'], 'Slab is 12 m by 20 m.');
    expect(popped, 'conversation-1');
  });

  testWidgets('site inspection sheet asks for a saved site first', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SiteInspectionSheet(
            productName: 'Ready-mixed concrete',
            storeName: 'Batching Plant',
            locations: const [],
            submit:
                ({
                  required locationId,
                  required preferredDate,
                  required key,
                  notes,
                }) async => 'unused',
          ),
        ),
      ),
    );
    expect(find.text('Save your site first'), findsOneWidget);
    final send = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Send request'),
    );
    expect(send.onPressed, isNull);
  });
}
