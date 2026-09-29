import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/directory_photo_loader.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/supplier_panels.dart';

import 'map_discovery_fakes.dart';

void main() {
  testWidgets(
    'directory photo attribution links do not select the supplier; rebuilds do not refetch',
    (tester) async {
      final repo = FakeDiscoveryRepository()
        ..photo = const DirectoryPhotoView(
          PlacePhotoView('https://photos.example.test/shop', [
            PlaceAuthorView(
              'Store Owner',
              'https://maps.google.com/contributor/1',
              null,
            ),
          ], 'https://maps.google.com/photo/1'),
          [],
        );
      final loader = DirectoryPhotoLoader(repo);
      final links = <Uri>[];
      var selections = 0;
      Widget row(bool selected) => MaterialApp(
        theme: BuyerTheme.light,
        home: Scaffold(
          body: SupplierRow(
            item: directorySupplier('one'),
            selected: selected,
            photoLoader: loader,
            onTap: () => selections++,
            onOpenLink: (uri) async => links.add(uri),
          ),
        ),
      );
      await tester.pumpWidget(row(false));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(repo.photoCalls, 1);
      expect(repo.detailCalls, 0);
      expect(find.text('Store Owner'), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image).first);
      expect((image.image as NetworkImage).url, repo.photo.photo!.uri);
      await tester.tap(find.text('Google Maps'));
      await tester.pumpAndSettle();
      expect(links.single.toString(), 'https://maps.google.com/photo/1');
      expect(selections, 0);
      await tester.pumpWidget(row(true));
      await tester.pump(const Duration(seconds: 1));
      expect(repo.photoCalls, 1);
      await tester.tap(find.text('Panda Construction Supply'));
      expect(selections, 1);
      await tester.pumpWidget(const SizedBox());
      loader.dispose();
    },
  );

  testWidgets(
    'verified rows use the actual store logo without a Google request',
    (tester) async {
      final repo = FakeDiscoveryRepository();
      final loader = DirectoryPhotoLoader(repo);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupplierRow(
              item: verifiedSupplier(
                'verified',
                logoUrl: 'https://media.example.test/store-logo',
              ),
              selected: false,
              photoLoader: loader,
              onTap: () {},
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      final image = tester.widget<Image>(find.byType(Image));
      expect(
        (image.image as NetworkImage).url,
        'https://media.example.test/store-logo',
      );
      expect(image.fit, BoxFit.contain);
      expect(repo.photoCalls, 0);
      expect(find.text('Google Maps'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      loader.dispose();
    },
  );

  testWidgets('rows removed during a fling do not fetch photos', (
    tester,
  ) async {
    final repo = FakeDiscoveryRepository();
    final loader = DirectoryPhotoLoader(repo);
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SupplierRow(
            item: directorySupplier('one'),
            selected: false,
            photoLoader: loader,
            onTap: () {},
          ),
        ),
      ),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    expect(repo.photoCalls, 0);
    loader.dispose();
  });

  testWidgets('thumbnail queue bounds concurrency and drops offscreen work', (
    tester,
  ) async {
    final repo = _PendingPhotos();
    final loader = DirectoryPhotoLoader(repo);
    var visible = true;
    final first = loader.load('one', () => true);
    final second = loader.load('two', () => true);
    final third = loader.load('three', () => visible);
    await tester.pump();
    expect(repo.pending.length, 2);
    visible = false;
    for (final request in repo.pending) {
      request.complete(const DirectoryPhotoView(null, []));
    }
    await tester.pump();
    expect(await third, isNull);
    expect(repo.pending.length, 2);
    await first;
    await second;
    loader.dispose();
  });

  testWidgets('thumbnail requests leave capacity for Places user actions', (
    tester,
  ) async {
    final repo = FakeDiscoveryRepository();
    var now = DateTime.utc(2026, 9, 29);
    final loader = DirectoryPhotoLoader(repo, now: () => now);
    final requests = [
      for (var i = 0; i < 16; i++) loader.load('$i', () => true),
    ];
    await tester.pump();
    expect(repo.photoCalls, 15);
    now = now.add(const Duration(seconds: 60));
    await tester.pump(const Duration(seconds: 60));
    expect(repo.photoCalls, 16);
    await Future.wait(requests);
    loader.dispose();
  });

  testWidgets('provider failure leaves a usable row without invented media', (
    tester,
  ) async {
    final repo = FakeDiscoveryRepository()
      ..detailsFailure = const DiscoveryFailure(
        DiscoveryFailureKind.provider,
        'Unavailable',
      );
    final loader = DirectoryPhotoLoader(repo);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SupplierRow(
            item: directorySupplier('one'),
            selected: false,
            photoLoader: loader,
            onTap: () {},
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsNothing);
    expect(find.text('Panda Construction Supply'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    loader.dispose();
  });
}

class _PendingPhotos extends FakeDiscoveryRepository {
  final pending = <Completer<DirectoryPhotoView>>[];
  @override
  Future<DirectoryPhotoView> directoryPhoto(String resultId) {
    final request = Completer<DirectoryPhotoView>();
    pending.add(request);
    return request.future;
  }
}
