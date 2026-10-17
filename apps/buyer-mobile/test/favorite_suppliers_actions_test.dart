import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/buyer_places_screens.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';

import 'map_discovery_fakes.dart';

class _Favorites extends FakeDiscoveryRepository {
  @override
  Future<List<FavoriteSupplierView>> favorites() async => const [
    FavoriteSupplierView(
      vendorId: 'vendor-1',
      name: 'BuildSphere Construction Supply',
      scoreText: 'New Vendor',
      currentlyDiscoverable: true,
    ),
  ];
}

Widget _app({
  void Function(BuildContext, String)? onOpenStore,
  void Function(BuildContext, String)? onMessage,
  double scale = 1,
}) => MaterialApp(
  theme: BuyerTheme.light,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child!,
  ),
  home: FavoriteSuppliersScreen(
    repository: _Favorites(),
    onOpenStore: onOpenStore,
    onMessage: onMessage,
  ),
);

void main() {
  testWidgets('the listing opens its store and Message starts the inquiry', (
    tester,
  ) async {
    final taps = <String>[];
    await tester.pumpWidget(
      _app(
        onOpenStore: (_, id) => taps.add('store:$id'),
        onMessage: (_, id) => taps.add('message:$id'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('BuildSphere Construction Supply'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'Message'));
    expect(taps, ['store:vendor-1', 'message:vendor-1']);
  });

  testWidgets('without handlers the row is inert and has no Message button', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    expect(find.text('Message'), findsNothing);
    expect(
      find.text('Remove BuildSphere Construction Supply from favorites'),
      findsOneWidget,
    );
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('lays out at 320px with text scale $scale', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _app(onOpenStore: (_, _) {}, onMessage: (_, _) {}, scale: scale),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
