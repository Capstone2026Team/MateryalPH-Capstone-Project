import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/archive_item_action.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/orders/order_details_screen.dart';
import 'package:materyalph/features/projects/project_archives_screen.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'orders_fakes.dart';
import 'typed_project_fixtures.dart';

const _id = '01995000-0000-7000-8000-000000000001';
Widget _app(Widget home) => MaterialApp(theme: BuyerTheme.light, home: home);

Map<String, Object?> _item(String type, {bool parentArchived = false}) => {
  'id': _id,
  'type': type,
  'name': 'House foundation',
  'budget_centavos': 3000000,
  'lock_version': 4,
  'project_id': _id,
  'project_name': type == 'PROJECT' ? null : 'Home renovation',
  'parent_archived': parentArchived,
  'archived_at': '2026-11-09T08:00:00Z',
  'delete_after': '2026-12-09T08:00:00Z',
  'remaining_days': 30,
  'can_restore': !parentArchived,
  'can_delete': true,
};

void main() {
  testWidgets(
    'archive tabs preserve data and require confirmation before restore or delete',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1100));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final client = api.MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
      );
      addTearDown(() => client.dio.close(force: true));
      final mutations = <RequestOptions>[];
      final types = <String>[];
      var removed = false;
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            Object? data;
            if (request.method == 'GET') {
              final type = request.queryParameters['type'] as String;
              types.add(type);
              data = {
                'items': removed
                    ? []
                    : [_item(type, parentArchived: type == 'WORK_PACKAGE')],
                'page': 1,
                'has_more': false,
              };
            } else {
              mutations.add(request);
              removed = true;
              data = {'id': _id};
            }
            handler.resolve(
              Response<Object?>(
                requestOptions: request,
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
      );
      final repo = ProjectsRepository(
        client: client,
        onSessionExpired: () async {},
      );
      await tester.pumpWidget(_app(ProjectArchivesScreen(repository: repo)));
      await tester.pumpAndSettle();
      expect(find.text('House foundation'), findsOneWidget);
      expect(
        find.text('30 days remaining before permanent deletion'),
        findsOneWidget,
      );
      expect(find.textContaining('Dec 9, 2026'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Restore'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(mutations, isEmpty);
      await tester.tap(find.text('Archived Work Packages'));
      await tester.pumpAndSettle();
      expect(types, containsAllInOrder(['PROJECT', 'WORK_PACKAGE']));
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Restore'))
            .onPressed,
        isNull,
      );
      expect(
        find.text(
          'Restore the parent project before restoring this work package.',
        ),
        findsOneWidget,
      );
      await tester.tap(
        find.widgetWithText(OutlinedButton, 'Delete Permanently'),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Are you sure you want to permanently delete this item? This action cannot be undone.',
        ),
        findsOneWidget,
      );
      expect(mutations, isEmpty);
      await tester.tap(find.widgetWithText(FilledButton, 'Delete Permanently'));
      await tester.pumpAndSettle();
      expect(
        mutations.single.path,
        '/buyers/work-packages/$_id/permanent-deletion',
      );
      expect(mutations.single.headers['Idempotency-Key'], isNotEmpty);
      expect(find.text('No archived items'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'blocked archive reason remains readable at 320 px with large text',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const message =
          'This work package cannot be archived because it contains an ongoing order. Please complete or cancel all active orders first.';
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ArchiveItemAction(
                  label: 'Archive Work Package',
                  allowed: false,
                  blocker: message,
                  onArchive: () => fail('Blocked archive action was invoked.'),
                ),
              ),
            ),
          ),
        ),
      );
      expect(
        tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
        isNull,
      );
      expect(find.text(message), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'restore failure preserves the item and retry uses the same idempotency key',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 1100));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final client = api.MateryalphApiClient(
        dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
      );
      addTearDown(() => client.dio.close(force: true));
      final mutations = <RequestOptions>[];
      var restored = false;
      client.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            if (request.method == 'GET') {
              handler.resolve(
                Response<Object?>(
                  requestOptions: request,
                  statusCode: 200,
                  data: {
                    'data': {
                      'items': restored ? [] : [_item('PROJECT')],
                      'page': 1,
                      'has_more': false,
                    },
                    'meta': <String, Object?>{},
                    'errors': <Object?>[],
                  },
                ),
              );
            } else {
              mutations.add(request);
              if (mutations.length == 1) {
                handler.reject(
                  DioException(
                    requestOptions: request,
                    type: DioExceptionType.badResponse,
                    response: Response<Object?>(
                      requestOptions: request,
                      statusCode: 503,
                      data: {
                        'data': null,
                        'meta': <String, Object?>{},
                        'errors': [
                          {
                            'code': 'SERVICE_UNAVAILABLE',
                            'message': 'Please try again.',
                          },
                        ],
                      },
                    ),
                  ),
                );
              } else {
                restored = true;
                handler.resolve(
                  Response<Object?>(
                    requestOptions: request,
                    statusCode: 200,
                    data: {
                      'data': {'id': _id},
                      'meta': <String, Object?>{},
                      'errors': <Object?>[],
                    },
                  ),
                );
              }
            }
          },
        ),
      );
      await tester.pumpWidget(
        _app(
          ProjectArchivesScreen(
            repository: ProjectsRepository(
              client: client,
              onSessionExpired: () async {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (var attempt = 0; attempt < 2; attempt++) {
        final restore = find.widgetWithText(FilledButton, 'Restore');
        await tester.ensureVisible(restore);
        await tester.tap(restore);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Restore').last);
        await tester.pumpAndSettle();
        if (attempt == 0) expect(find.text('House foundation'), findsOneWidget);
      }
      expect(mutations, hasLength(2));
      expect(mutations.first.path, '/buyers/projects/$_id/restore');
      expect(
        mutations.first.headers['Idempotency-Key'],
        mutations.last.headers['Idempotency-Key'],
      );
      expect(find.text('No archived items'), findsOneWidget);
    },
  );

  for (final (state, allowed) in [
    ('CANCELLED', true),
    ('CANCELLED', false),
    ('PROCESSING', true),
  ]) {
    testWidgets(
      'Rescan Suppliers is restricted to cancelled project orders: $state, allowed $allowed',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 1200));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final budget = api.standardSerializers.serializeWith(
          api.ProjectBudget.serializer,
          typedBudget({'budget_centavos': 3000000}),
        );
        final repository = FakeOrdersRepository(
          detail: orderDetail(
            state: state,
            projectContext: {
              'work_package': {'name': 'Foundation', 'lines': <Object?>[]},
              'budget': budget,
              'can_rescan_suppliers': allowed,
            },
          ),
        );
        var rescans = 0;
        await tester.pumpWidget(
          _app(
            OrderDetailsScreen(
              orderId: 'order-1',
              repository: repository,
              onRescanSuppliers: (context, id, lock) async {
                expect(id, 'order-1');
                expect(lock, 3);
                rescans++;
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (state == 'CANCELLED') {
          await tester.ensureVisible(find.text('Rescan Suppliers'));
          if (allowed) {
            await tester.tap(find.text('Rescan Suppliers'));
            await tester.pumpAndSettle();
            expect(rescans, 1);
          } else {
            expect(
              tester
                  .widget<FilledButton>(
                    find.widgetWithText(FilledButton, 'Rescan Suppliers'),
                  )
                  .onPressed,
              isNull,
            );
            expect(rescans, 0);
          }
        } else {
          expect(find.text('Rescan Suppliers'), findsNothing);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }
}
