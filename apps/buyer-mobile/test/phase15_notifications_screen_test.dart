import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/notifications/notification_settings_screen.dart';
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
      'notification preferences popup groups required delivery at 320px scale $scale',
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
        final repository = NotificationsRepository(client, () async {});
        addTearDown(repository.inbox.dispose);
        Widget app(Widget home) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: BuyerTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: home,
        );
        await tester.pumpWidget(
          app(NotificationsScreen(repository: repository, open: (_) async {})),
        );
        await tester.pumpAndSettle();
        expect(find.text('Account access changed'), findsOneWidget);
        expect(find.text('1 unread'), findsOneWidget);
        expect(find.byTooltip('Notification preferences'), findsNothing);
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(
          app(NotificationSettingsScreen(repository: repository)),
        );
        await tester.pumpAndSettle();
        expect(find.text('Notification settings'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text(
            'Account safety, legal and transaction notices stay enabled across all available channels.',
          ),
          120,
        );
        expect(
          find.text(
            'Account safety, legal and transaction notices stay enabled across all available channels.',
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('In-app'),
          -120,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.byType(SwitchListTile), findsNWidgets(3));
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
