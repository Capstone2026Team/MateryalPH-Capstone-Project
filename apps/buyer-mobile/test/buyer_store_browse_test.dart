import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/screens/buyer_store_browse_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

class _StoreRepository extends BuyerStoreRepository {
  _StoreRepository({this.hoursAvailable = true});

  final bool hoursAvailable;

  @override
  Future<PublicStoreProfile> profile(String id) async => PublicStoreProfile(
    (b) => b
      ..id = id
      ..publicStoreName = 'Sample Store'
      ..vacationMode = true
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
      ..timeZone = PublicStoreProfileTimeZoneEnum.asiaSlashManila
      ..hoursStatus = hoursAvailable
          ? PublicStoreProfileHoursStatusEnum.AVAILABLE
          : PublicStoreProfileHoursStatusEnum.UNAVAILABLE
      ..address.replace(
        PublicAddressSummary(
          (b) => b
            ..formattedAddress = '123 Aurora Boulevard, Quezon City'
            ..cityMunicipality = 'Quezon City'
            ..province = 'Metro Manila',
        ),
      )
      ..scoreLabel.replace(
        ScoreLabel(
          (b) => b
            ..kind = ScoreLabelKindEnum.NEW_VENDOR
            ..text = 'New Vendor',
        ),
      ),
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

    expect(find.textContaining('This store has paused new procurement'), findsOneWidget);
    expect(find.text('Store Hours'), findsOneWidget);
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('8:00 AM – 5:00 PM'), findsWidgets);
    await tester.scrollUntilVisible(find.text('Sunday'), 150, scrollable: find.byType(Scrollable));
    expect(find.text('Sunday'), findsOneWidget);
    expect(find.text('Closed'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Today’s hours: Closed'),
      200,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Today’s hours: Closed'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Date-specific schedule'), 100, scrollable: find.byType(Scrollable));
    expect(find.text('Date-specific schedule'), findsOneWidget);
  });

  testWidgets('unusable saved hours show Hours unavailable, never invented hours', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerPublicStoreProfileScreen(
          storeId: 'store-1',
          repository: _StoreRepository(hoursAvailable: false),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Hours unavailable'), findsOneWidget);
  });
}
