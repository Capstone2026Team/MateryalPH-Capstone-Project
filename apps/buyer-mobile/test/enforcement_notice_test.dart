import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/notifications/notification_scope.dart';
import 'package:materyalph/features/notifications/notifications_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  testWidgets(
    'Buyer sees an enforcement popup and acknowledges only that notice',
    (tester) async {
      var read = false;
      var noticeId = 'notice-1';
      final client = MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1')),
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              Object data;
              if (options.path.endsWith('/resolve')) {
                data = {'path': '/settings'};
              } else if (options.path.endsWith('/read')) {
                read = true;
                data = {'read': true};
              } else if (options.path.endsWith('/navigation-updates')) {
                data = <String, Object>{};
              } else if (options.path.endsWith('/realtime')) {
                data = {'enabled': false};
              } else {
                data = read
                    ? []
                    : [
                        {
                          'id': noticeId,
                          'category': 'SUSPENSION',
                          'title': 'Account warning',
                          'body': 'Repeated missed pickups. No access changes.',
                          'mandatory': true,
                          'read_at': null,
                          'created_at': '2026-11-08T02:00:00Z',
                        },
                      ];
              }
              handler.resolve(
                Response<Object>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'data': data,
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
      final navigator = GlobalKey<NavigatorState>();
      Widget app({bool active = true}) => MaterialApp(
        navigatorKey: navigator,
        builder: (_, child) => NotificationScope(
          repository: repository,
          navigatorKey: navigator,
          active: active,
          child: child!,
        ),
        home: const Scaffold(body: Text('Buyer home')),
      );
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(find.text('Account warning'), findsOneWidget);
      expect(
        find.text('Repeated missed pickups. No access changes.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Acknowledge'));
      await tester.pumpAndSettle();
      expect(read, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
      read = false;
      noticeId = 'notice-2';
      unawaited(repository.inbox.refresh());
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.pumpWidget(app(active: false));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      repository.dispose();
    },
  );
}
