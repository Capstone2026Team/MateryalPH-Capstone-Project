import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/screens/buyer_store_browse_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

class _StoreRepository extends BuyerStoreRepository {
  _StoreRepository({this.hoursAvailable = true});

  final bool hoursAvailable;

  static Date _date(int offset) {
    final day = DateTime.utc(2026, 9, 28).add(Duration(days: offset));
    return Date(day.year, day.month, day.day);
  }

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Future<PublicStoreProfile> profile(String id) async => PublicStoreProfile(
    (b) => b
      ..id = id
      ..publicStoreName = 'Sample Store'
      ..vacationMode = true
      ..operatingSchedule.replace([
        if (hoursAvailable)
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
      // Monday 28 September 2026 in Asia/Manila, closed by a dated override.
      ..week.replace([
        if (hoursAvailable)
          for (var offset = 0; offset < 7; offset++)
            StoreHoursDay(
              (b) => b
                ..date = _date(offset)
                ..dayOfWeek = offset + 1
                ..weekday = _weekdays[offset]
                ..status = offset == 0 || offset == 6
                    ? StoreHoursDayStatusEnum.CLOSED
                    : StoreHoursDayStatusEnum.OPEN
                ..opensAt = offset == 0 || offset == 6 ? null : '08:00'
                ..closesAt = offset == 0 || offset == 6 ? null : '17:00'
                ..source_ = offset == 0
                    ? StoreHoursDaySource_Enum.DATE_OVERRIDE
                    : StoreHoursDaySource_Enum.WEEKLY,
            ),
      ])
      ..openNow.replace(
        StoreOpenNow(
          (b) => b
            ..status = hoursAvailable
                ? StoreOpenNowStatusEnum.CLOSED
                : StoreOpenNowStatusEnum.UNAVAILABLE
            ..basis = hoursAvailable
                ? StoreOpenNowBasisEnum.DATE_OVERRIDE
                : StoreOpenNowBasisEnum.SAVED_SCHEDULE
            ..nextOpening = hoursAvailable
                ? (StoreNextOpeningBuilder()
                    ..date = Date(2026, 9, 29)
                    ..weekday = 'Tuesday'
                    ..opensAt = '08:00')
                : null,
        ),
      )
      ..allClosed = false
      ..hoursAsOf = DateTime.utc(2026, 9, 28, 2)
      ..hoursNotice = 'Hours are informational only.'
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
  testWidgets(
    'public profile shows today, the full dated week and the date override',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerPublicStoreProfileScreen(
            storeId: 'store-1',
            repository: _StoreRepository(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('This store has paused new procurement'),
        findsOneWidget,
      );
      expect(find.text('Store Hours'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Today · Monday, Sep 28'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Closed · date-specific'), findsOneWidget);
      expect(
        find.text('Closed now · opens Tuesday Sep 29, 8:00 AM'),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.text('Sunday, Oct 4'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('8:00 AM – 5:00 PM'), findsWidgets);
      expect(
        find.text('Closed'),
        findsOneWidget,
        reason: 'Sunday is an explicit Closed day.',
      );
    },
  );

  testWidgets(
    'unusable saved hours show Hours unavailable, never invented hours',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerPublicStoreProfileScreen(
            storeId: 'store-1',
            repository: _StoreRepository(hoursAvailable: false),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Hours unavailable'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Hours unavailable'), findsOneWidget);
      expect(find.textContaining('8:00'), findsNothing);
    },
  );
}
