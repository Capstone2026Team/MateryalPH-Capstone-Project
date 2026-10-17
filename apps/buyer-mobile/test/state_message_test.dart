import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/procurement_components.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/notifications/notifications_repository.dart';
import 'package:materyalph/features/notifications/notifications_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

Widget _host(Widget child, {double scale = 1}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: BuyerTheme.light,
  builder: (context, page) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: page!,
  ),
  home: child,
);

String? _artwork(WidgetTester tester) {
  final images = tester.widgetList<Image>(find.byType(Image));
  if (images.isEmpty) return null;
  final provider = images.single.image;
  return provider is AssetImage ? provider.assetName : null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'))).load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });

  test('every illustration in the set is a bundled asset', () async {
    for (final art in StateArtwork.values) {
      final bytes = await rootBundle.load(art.asset);
      expect(bytes.lengthInBytes, greaterThan(0), reason: art.asset);
    }
  });

  testWidgets('each state kind shows its illustration from the set', (
    tester,
  ) async {
    const expected = {
      StateKind.empty: 'assets/states/no-results.png',
      StateKind.offline: 'assets/states/no-connection.png',
      StateKind.needsLocation: 'assets/states/location.png',
      StateKind.error: null,
      StateKind.forbidden: null,
    };
    for (final entry in expected.entries) {
      await tester.pumpWidget(
        _host(
          Scaffold(
            body: StateMessage(kind: entry.key, title: 'Title', message: 'Why'),
          ),
        ),
      );
      expect(_artwork(tester), entry.value, reason: entry.key.name);
    }

    await tester.pumpWidget(
      _host(
        const Scaffold(
          body: StateMessage(
            kind: StateKind.empty,
            artwork: StateArtwork.cart,
            title: 'Your cart is empty',
            message: 'Add materials.',
          ),
        ),
      ),
    );
    expect(_artwork(tester), 'assets/states/cart.png');
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'an empty inbox centers the notifications illustration at 320px '
      'scale $scale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final client = MateryalphApiClient(
          dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1')),
          interceptors: [
            InterceptorsWrapper(
              onRequest: (options, handler) => handler.resolve(
                Response<Object>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'data': <Object?>[],
                    'meta': <String, Object?>{},
                    'errors': <Object?>[],
                  },
                ),
              ),
            ),
          ],
        );
        final repository = NotificationsRepository(client, () async {});
        addTearDown(repository.inbox.dispose);
        await tester.pumpWidget(
          _host(
            NotificationsScreen(repository: repository, open: (_) async {}),
            scale: scale,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text("You're all caught up"), findsOneWidget);
        expect(_artwork(tester), 'assets/states/notifications.png');
        // Nothing to count or mark, so the summary row stays out of the way.
        expect(find.text('No unread notifications'), findsNothing);
        expect(find.text('Mark all as read'), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
