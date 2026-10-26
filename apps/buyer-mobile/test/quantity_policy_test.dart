import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/procurement_components.dart';
import 'package:materyalph/design_system/quantity_policy.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

void main() {
  test('selling units distinguish measurements from whole packages', () {
    expect(sellingQuantityLabel('CUM'), 'Volume (m³)');
    expect(sellingQuantityLabel('L'), 'Volume (L)');
    expect(sellingQuantityLabel('US_GAL'), 'Volume (US gal)');
    expect(sellingQuantityLabel('GAL'), 'Gallon cans');
    expect(sellingQuantityLabel('BAG'), 'Bags');
    expect(validSellingQuantity('1.1250', 3), isTrue);
    expect(validSellingQuantity('1.1251', 3), isFalse);
    expect(validSellingQuantity('2.0000', 0), isTrue);
    expect(validSellingQuantity('2.5', 0), isFalse);
    expect(validSellingQuantity('0', 3), isFalse);
    expect(validSellingQuantity('1.00001', 4), isFalse);
    final wire = <String, Object?>{
      'id': '01995000-0000-7000-8000-000000000003',
      'code': 'CUM',
      'name': 'Cubic meter',
      'precision': 3,
      'quantity_policy': {
        'mode': 'MEASURED',
        'dimension': 'VOLUME',
        'precision': 3,
        'step': '0.001',
      },
    };
    final enriched = api.standardSerializers.deserializeWith(
      api.ProjectMaterialUnit.serializer,
      wire,
    )!;
    expect(enriched.quantityPolicy?.mode.name, 'MEASURED');
    expect(enriched.quantityPolicy?.step, '0.001');
    wire.remove('quantity_policy');
    expect(
      api.standardSerializers
          .deserializeWith(api.ProjectMaterialUnit.serializer, wire)!
          .quantityPolicy,
      isNull,
    );
  });

  test(
    'line previews use exact half-up centavos, including large quantities',
    () {
      expect(lineAmountCentavos('0.499', 1), 0);
      expect(lineAmountCentavos('0.500', 1), 1);
      expect(lineAmountCentavos('0.501', 1), 1);
      expect(lineAmountCentavos('1000000', 100000000000), 100000000000000000);
      expect(() => lineAmountCentavos('1.00001', 100), throwsArgumentError);
    },
  );

  testWidgets('unit precision changes preserve text and require correction', (
    tester,
  ) async {
    var value = '1.25';
    var precision = 3;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return DecimalQuantityField(
                label: precision == 0 ? 'Gallon cans' : 'Volume (US gal)',
                value: value,
                unitName: '',
                decimals: precision,
                onChanged: (text) => value = text,
              );
            },
          ),
        ),
      ),
    );
    update(() => precision = 0);
    await tester.pump();
    expect(find.text('1.25'), findsOneWidget);
    expect(
      find.text('Review the quantity for this selling unit.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), 'bad');
    expect(value, 'bad');
    await tester.enterText(find.byType(TextField), '2');
    await tester.pump();
    expect(value, '2');
    expect(
      find.text('Review the quantity for this selling unit.'),
      findsNothing,
    );
  });
}
