import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/delivery_vehicle_card.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/orders/order_models.dart';

void main() {
  testWidgets(
    'vehicle card shows physical details and confirmation status at narrow widths',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: const Scaffold(
            body: BuyerDeliveryVehicleCard(
              vehicle: ConfirmedVehicleView(
                name: 'Concrete mixer A',
                brand: 'Isuzu',
                vehicleType: 'CONCRETE_MIXER',
                capacityKg: '14400.0000',
                mixerCapacityM3: '6.0000',
                heavyClassification: 'HEAVY',
                vehicles: 1,
                trips: 2,
                perTripCentavos: 50000,
              ),
              status: 'Vendor confirmed for this order',
            ),
          ),
        ),
      );
      expect(find.text('Concrete mixer A'), findsOneWidget);
      expect(find.textContaining('14400 kg payload'), findsOneWidget);
      expect(find.textContaining('6 m³ mixer'), findsOneWidget);
      expect(find.text('Vendor confirmed for this order'), findsOneWidget);
      expect(find.text('Vehicle photo not recorded'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
