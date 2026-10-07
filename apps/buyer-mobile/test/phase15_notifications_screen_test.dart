import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/notifications/notifications_repository.dart';
import 'package:materyalph/features/notifications/notifications_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  setUpAll(() async {
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'))).load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'notification preferences explain required delivery at 320px scale $scale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final client = MateryalphApiClient(
          dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1')),
          interceptors: [
            InterceptorsWrapper(
              onRequest: (options, handler) {
                final preferences = options.path.endsWith('/preferences');
                handler.resolve(
                  Response<Object>(
                    requestOptions: options,
                    statusCode: 200,
                    data: {
                      'data': preferences
                          ? [
                              {
                                'category': 'SECURITY',
                                'mandatory': true,
                                'explanation':
                                    'Required for account safety and legal duties.',
                                'in_app': true,
                                'email': true,
                                'push': true,
                              },
                              {
                                'category': 'MARKETING',
                                'mandatory': false,
                                'explanation':
                                    'Choose where optional updates arrive.',
                                'in_app': true,
                                'email': false,
                                'push': false,
                              },
                            ]
                          : [
                              {
                                'id': 'synthetic-notice',
                                'category': 'SECURITY',
                                'title': 'Account access changed',
                                'body':
                                    'Review your current account permissions.',
                                'mandatory': true,
                                'read_at': null,
                                'created_at': '2026-10-05T00:00:00Z',
                              },
                            ],
                      'meta': <String, Object?>{},
                      'errors': <Object?>[],
                    },
                  ),
                );
              },
            ),
          ],
        );
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: BuyerTheme.light,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: NotificationsScreen(
              repository: NotificationsRepository(client, () async {}),
              open: (_) async {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Account access changed'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Preferences'));
        await tester.pumpAndSettle();
        if (scale > 1) {
          await tester.scrollUntilVisible(
            find.text(
              'Always enabled · In-app, email and registered push devices',
            ),
            120,
          );
        }
        expect(
          find.text(
            'Always enabled · In-app, email and registered push devices',
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            '../../../docs/design/evidence/phase-15/buyer-320-preferences-${scale.toInt()}x.png',
          ),
        );
        await tester.scrollUntilVisible(find.text('In-app'), 120);
        expect(find.byType(SwitchListTile), findsNWidgets(3));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
