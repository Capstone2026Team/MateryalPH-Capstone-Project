import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/screens/buyer_store_browse_screen.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph/features/trust/trust_models.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

import 'item_procurement_fakes.dart';

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
      ..publicPhone = '(0917) 123-4567'
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
      expect(find.text('Sample Store'), findsOneWidget);
      expect(find.text('New Vendor'), findsOneWidget);
      expect(find.text('Quezon City, Metro Manila'), findsOneWidget);
      expect(find.text('Shop Front'), findsNothing);
      expect(find.text('Products'), findsOneWidget);
      await tester.tap(find.text('Store Profile'));
      await tester.pumpAndSettle();
      expect(find.text('123 Aurora Boulevard, Quezon City'), findsOneWidget);
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
      await tester.tap(find.text('Store Profile'));
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

  testWidgets('Products tab lists the store listings and sorts on the server', (
    tester,
  ) async {
    final sorts = <ListingSort>[];
    String? opened;
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerPublicStoreProfileScreen(
          storeId: 'store-1',
          repository: _StoreRepository(),
          loadProducts: (sort, cursor) async {
            sorts.add(sort);
            return searchPage([
              listingCard('listing-1', name: 'KD Wood Mouldings', price: 5200),
              listingCard('listing-2', name: 'SikaGrout 112 PH', price: 65500),
            ]);
          },
          onOpenListing: (context, id) => opened = id,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('KD Wood Mouldings'), findsOneWidget);
    expect(find.text('SikaGrout 112 PH'), findsOneWidget);
    expect(sorts, [
      ListingSort.bestDeal,
    ], reason: 'Products is the first tab and opens on Best Deal.');

    await tester.tap(find.text('Price'));
    await tester.pumpAndSettle();
    expect(sorts.last, ListingSort.price);

    await tester.ensureVisible(find.text('KD Wood Mouldings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('KD Wood Mouldings'));
    expect(opened, 'listing-1');
  });

  testWidgets(
    'Store Profile shows the published VCS, rating averages and badges',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerPublicStoreProfileScreen(
            storeId: 'store-1',
            repository: _StoreRepository(),
            loadRating: () async => const StoreRatingView(
              ratingCount: 12,
              serviceQuality: '4.70',
              speed: '4.50',
              scoreLabel: 'VPS 4.40 of 5',
              newVendor: false,
              vcs: '4.62',
              mqs: '4.66',
              vps: '4.40',
              badges: [
                StoreBadgeView(
                  code: 'HIGHLY_RATED',
                  name: 'Highly Rated',
                  description:
                      'Vendor Community Score of 4.50 or higher from 10+ verified ratings (last 90 days).',
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Store Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Store rating'), findsOneWidget);
      expect(find.text('4.62'), findsOneWidget);
      expect(find.text('Vendor Community Score'), findsOneWidget);
      expect(find.text('12 verified store ratings'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Service Quality: 4.70 of 5'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Delivery / Processing Speed: 4.50 of 5'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Material Quality Score: 4.66 of 5'),
        findsOneWidget,
      );
      expect(find.text('Highly Rated'), findsOneWidget);
    },
  );

  testWidgets(
    'below the sample gate the store reads New Vendor with no combined score',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerPublicStoreProfileScreen(
            storeId: 'store-1',
            repository: _StoreRepository(),
            loadRating: () async => const StoreRatingView(
              ratingCount: 2,
              serviceQuality: '5.00',
              speed: '4.00',
              scoreLabel: 'New Vendor — Building Track Record',
              newVendor: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Store Profile'));
      await tester.pumpAndSettle();

      expect(find.text('New Vendor — Building Track Record'), findsOneWidget);
      expect(find.text('2 verified store ratings'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Service Quality: 5.00 of 5'),
        findsOneWidget,
      );
      expect(find.textContaining('Material Quality Score'), findsNothing);
      expect(find.textContaining('Vendor Performance Score'), findsNothing);
    },
  );

  testWidgets('a failed store rating offers retry and keeps the profile', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerPublicStoreProfileScreen(
          storeId: 'store-1',
          repository: _StoreRepository(),
          loadRating: () async {
            calls++;
            if (calls == 1) throw StateError('offline');
            return const StoreRatingView(
              ratingCount: 0,
              scoreLabel: 'New Vendor — Building Track Record',
              newVendor: true,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Store Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Store rating could not load.'), findsOneWidget);
    expect(find.text('123 Aurora Boulevard, Quezon City'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('0 verified store ratings'), findsOneWidget);
  });

  testWidgets(
    'header icons message, show on Map and search; distance comes from the Map',
    (tester) async {
      var messaged = 0;
      var mapped = 0;
      String? browsed;
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerPublicStoreProfileScreen(
            storeId: 'store-1',
            repository: _StoreRepository(),
            distanceMeters: 1900,
            onMessage: () => messaged++,
            onShowOnMap: (context) => mapped++,
            onBrowseProducts: (context, id, name) => browsed = '$id:$name',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1.9 km away'), findsOneWidget);
      expect(
        find.text('Message'),
        findsNothing,
        reason:
            'Message is an icon in the header, not a button in the page body.',
      );
      await tester.tap(find.byTooltip('Message Sample Store'));
      await tester.tap(find.byTooltip('Show Sample Store on the Map'));
      await tester.tap(find.byTooltip('Search Sample Store products'));
      expect(messaged, 1);
      expect(mapped, 1);
      expect(browsed, 'store-1:Sample Store');
    },
  );

  testWidgets('without a Map distance the store listings supply it', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerPublicStoreProfileScreen(
          storeId: 'store-1',
          repository: _StoreRepository(),
          loadProducts: (sort, cursor) async =>
              searchPage([listingCard('listing-1', distance: 2400)]),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('2.4 km away'), findsOneWidget);
    expect(find.byTooltip('Show Sample Store on the Map'), findsNothing);
  });

  testWidgets(
    'the public phone number opens Call or Send SMS outside the app',
    (tester) async {
      final opened = <Uri>[];
      var canOpen = true;
      await tester.pumpWidget(
        MaterialApp(
          home: BuyerPublicStoreProfileScreen(
            storeId: 'store-1',
            repository: _StoreRepository(),
            openExternal: (uri) async {
              opened.add(uri);
              return canOpen;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Store Profile'));
      await tester.pumpAndSettle();

      Future<void> choose(String action) async {
        await tester.ensureVisible(find.text('(0917) 123-4567'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('(0917) 123-4567'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(action));
        await tester.pumpAndSettle();
      }

      await choose('Call');
      await choose('Send SMS');
      expect(opened.map((uri) => uri.toString()), [
        'tel:09171234567',
        'sms:09171234567',
      ]);

      canOpen = false;
      await choose('Call');
      expect(
        find.text(
          'This device cannot place calls. The number is (0917) 123-4567.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('Products tab asks for a location when none is chosen', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BuyerPublicStoreProfileScreen(
          storeId: 'store-1',
          repository: _StoreRepository(),
          loadProducts: (sort, cursor) async => null,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a location first'), findsOneWidget);
  });
}
