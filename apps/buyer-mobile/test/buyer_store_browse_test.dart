import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/screens/buyer_store_browse_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

class _StoreRepository extends BuyerStoreRepository {
  @override
  Future<PublicStoreProfile> profile(String id) async => PublicStoreProfile(
    (b) => b
      ..id = id
      ..publicStoreName = 'Sample Store'
      ..operatingSchedule.replace([
        for (var day = 1; day <= 7; day++)
          StoreOperatingDay(
            (b) => b
              ..dayOfWeek = day
              ..status = day == 7
                  ? StoreOperatingDayStatusEnum.CLOSED
                  : StoreOperatingDayStatusEnum.OPEN
              ..opensAt = day == 7 ? null : '08:00'
              ..closesAt = day == 7 ? null : '17:00',
          ),
      ])
      ..effectiveToday.replace(
        StoreOperatingDay(
          (b) => b
            ..dayOfWeek = 1
            ..status = StoreOperatingDayStatusEnum.CLOSED,
        ),
      )
      ..effectiveDate = Date(2026, 9, 28)
      ..effectiveSource = PublicStoreProfileEffectiveSourceEnum.DATE_OVERRIDE
      ..timeZone = PublicStoreProfileTimeZoneEnum.asiaSlashManila,
  );
}

void main() {
  testWidgets('public profile shows saved weekly hours and the date override', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerPublicStoreProfileScreen(
          storeId: 'store-1',
          repository: _StoreRepository(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Store Hours'), findsOneWidget);
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('8:00 AM – 5:00 PM'), findsNWidgets(6));
    expect(find.text('Sunday'), findsOneWidget);
    expect(find.text('Closed'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Today’s hours: Closed'),
      200,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Today’s hours: Closed'), findsOneWidget);
    expect(find.text('Date-specific schedule'), findsOneWidget);
  });
}
