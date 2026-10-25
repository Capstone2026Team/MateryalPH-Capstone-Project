import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/google_place_content.dart';

void main() {
  const photos = [
    PlacePhotoView('https://example.test/photo-1.jpg', [
      PlaceAuthorView('Aly', 'https://maps.example.test/aly', null),
    ], 'https://maps.example.test/photo-1'),
    PlacePhotoView('https://example.test/photo-2.jpg', [
      PlaceAuthorView('Ben', null, null),
    ], null),
  ];

  Future<List<Uri>> pump(WidgetTester tester, {double width = 390}) async {
    final opened = <Uri>[];
    tester.view.physicalSize = Size(width * 2, 1600);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: GooglePlacePhotos(
                photos: photos,
                onOpenLink: (uri) async => opened.add(uri),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    return opened;
  }

  testWidgets('steps through photos with buttons and keeps attribution', (
    tester,
  ) async {
    final opened = await pump(tester);

    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.bySemanticsLabel('Photo 1 of 2'), findsOneWidget);
    expect(find.text('Google Maps'), findsOneWidget);
    expect(find.byTooltip('Previous photo'), findsNothing);

    await tester.tap(find.text('Aly'));
    await tester.tap(find.byTooltip('View photo on Google Maps'));
    expect(opened, [
      Uri.parse('https://maps.example.test/aly'),
      Uri.parse('https://maps.example.test/photo-1'),
    ]);

    await tester.tap(find.byTooltip('Next photo'));
    await tester.pumpAndSettle();

    expect(find.text('2 / 2'), findsOneWidget);
    expect(find.text('Ben'), findsOneWidget);
    expect(find.text('Google Maps'), findsOneWidget);
    expect(find.byTooltip('Next photo'), findsNothing);
    expect(find.byTooltip('View photo on Google Maps'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('fits a 320 px screen at 2x text', (tester) async {
    await pump(tester, width: 320);
    expect(tester.takeException(), isNull);
  });
}
