import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/form_dialog.dart';
import 'package:materyalph/design_system/components/work_package_attachment.dart';
import 'package:materyalph/design_system/ranking_weights.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/projects/project_editor.dart';
import 'package:materyalph/features/projects/project_ranking_preferences_screen.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph/features/projects/projects_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

const projectId = '01995000-0000-7000-8000-000000000001';
const locationId = '01995000-0000-7000-8000-000000000002';
const defaults = {
  'material_match': 40,
  'budget_fit': 25,
  'distance': 20,
  'vps': 15,
};
Map<String, Object?> projectFixture() => {
  'id': projectId,
  'name': 'Renovation',
  'status': 'ACTIVE',
  'budget_centavos': 123450,
  'starts_on': '2026-10-01',
  'ends_on': '2026-10-30',
  'lock_version': 2,
  'budget': {
    'budget_centavos': 123450,
    'pending_centavos': 0,
    'actual_centavos': 0,
    'awaiting_recovery_centavos': 0,
    'committed_centavos': 0,
    'remaining_centavos': 123450,
    'utilization_percent': '0.00',
    'warning': false,
    'label': 'UNDER_BUDGET',
    'allocated_centavos': 0,
    'unallocated_centavos': 123450,
    'pending_confirmation_count': 0,
    'processing_fee_status': 'PENDING_PAYMENT_CHANNEL_UNTIL_QUOTED',
  },
  'sites': <Object?>[],
  'packages': {'items': <Object?>[], 'page': 1, 'has_more': false},
};

ProjectsRepository repository(
  void Function(RequestOptions, RequestInterceptorHandler) request,
) {
  final client = api.MateryalphApiClient(
    dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
    interceptors: [InterceptorsWrapper(onRequest: request)],
  );
  return ProjectsRepository(
    client: client,
    onSessionExpired: () async => fail('A form must not end the session'),
  );
}

void respond(
  RequestOptions options,
  RequestInterceptorHandler handler,
  Object data,
) => handler.resolve(
  Response<Object?>(
    requestOptions: options,
    statusCode: 200,
    data: {'data': data, 'meta': <String, Object?>{}, 'errors': <Object?>[]},
  ),
);
Finder field(String label) => find.byWidgetPredicate(
  (w) => w is TextField && w.decoration?.labelText == label,
);

void main() {
  testWidgets('editable Work Package originals are not labelled locked', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WorkPackageAttachment(
            original: {'name': 'Planning draft'},
            version: 1,
            locked: false,
          ),
        ),
      ),
    );
    expect(find.text('Editable Buyer draft · version 1'), findsOneWidget);
    expect(find.textContaining('Locked Buyer original'), findsNothing);
  });
  setUpAll(() async {
    for (final font in [
      ('Inter', 'assets/fonts/Inter-Variable.ttf'),
      ('MaterialIcons', 'fonts/MaterialIcons-Regular.otf'),
      (
        'packages/lucide_icons_flutter/Lucide',
        'packages/lucide_icons_flutter/assets/lucide.ttf',
      ),
    ]) {
      await (FontLoader(font.$1)..addFont(rootBundle.load(font.$2))).load();
    }
  });
  for (final viewport in [(320.0, 2.0), (390.0, 1.0), (1024.0, 1.0)]) {
    testWidgets(
      'Project authoring and ranking reflow at ${viewport.$1}px and ${viewport.$2}x text',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(viewport.$1, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final repo = repository(
          (options, handler) => respond(options, handler, {
            'weights': defaults,
            'default_weights': defaults,
            'personalized': false,
            'version': 0,
            'defaults_version': 0,
            'algorithm_version': 'fms.normalized-weighted-sum.v1',
          }),
        );
        for (final page in [
          (
            'create',
            ProjectEditor(repository: repo, chooseLocation: () async => null),
          ),
          ('ranking', ProjectRankingPreferencesScreen(repository: repo)),
          (
            'package',
            WorkPackageEditor(
              repository: repo,
              project: projectFixture(),
              chooseLocation: () async => null,
            ),
          ),
        ]) {
          await tester.pumpWidget(
            MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: BuyerTheme.light,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(viewport.$2)),
                child: child!,
              ),
              home: page.$2,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          if (viewport.$1 == 390) {
            await expectLater(
              find.byType(MaterialApp),
              matchesGoldenFile(
                '../../../docs/design/evidence/phase-10/buyer-project-${page.$1}-390.png',
              ),
            );
          }
          await tester.pumpWidget(const SizedBox());
        }
      },
    );
  }
  test(
    'Project percentages remain whole and total 100 at every slider position',
    () {
      for (final key in defaults.keys) {
        for (var value = 0; value <= 100; value++) {
          final weights = rebalanceRankingWeights(
            defaults,
            key,
            value,
            defaults: defaults,
          );
          expect(weights[key], value);
          expect(weights.values.reduce((a, b) => a + b), 100);
          expect(weights.values.every((v) => v >= 0 && v <= 100), isTrue);
        }
      }
      final exclusive = rebalanceRankingWeights(
        defaults,
        'material_match',
        100,
        defaults: defaults,
      );
      expect(
        rebalanceRankingWeights(
          exclusive,
          'material_match',
          40,
          defaults: defaults,
        ),
        defaults,
      );
    },
  );

  testWidgets(
    'form dialog keeps a focused controller alive through its exit animation',
    (tester) async {
      var disposed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                final controller = TextEditingController();
                await showBuyerFormDialog<void>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    content: TextField(controller: controller),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );
                controller.dispose();
                disposed = true;
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Focused field');
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(disposed, isFalse);
      await tester.pumpAndSettle();
      expect(disposed, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  for (final editing in [false, true]) {
    testWidgets(
      '${editing ? 'edit' : 'create'} Project saves once and safely returns while fields are focused',
      (tester) async {
        final completion = Completer<void>();
        var requests = 0;
        ProjectData? saved;
        final repo = repository((options, handler) async {
          requests++;
          expect(options.method, editing ? 'PATCH' : 'POST');
          final data = projectObject(options.data);
          expect(data['budget_centavos'], 123450);
          if (editing) expect(data['lock_version'], 2);
          await completion.future;
          respond(options, handler, projectFixture());
        });
        await tester.pumpWidget(
          MaterialApp(
            theme: BuyerTheme.light,
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    saved = await Navigator.of(context).push<ProjectData>(
                      MaterialPageRoute(
                        builder: (_) => ProjectEditor(
                          repository: repo,
                          project: editing ? projectFixture() : null,
                          chooseLocation: () async =>
                              const DiscoveryOrigin.saved(
                                locationId: locationId,
                                label: 'Saved site',
                                point: GeoPoint(14.6, 121),
                              ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        if (!editing) {
          await tester.enterText(field('Project name'), 'Renovation');
          await tester.enterText(field('Overall budget (₱)'), '1234.50');
          // Date picker writes ISO dates to these read-only display controllers.
          tester.widget<TextField>(field('Start date')).controller!.text =
              '2026-10-01';
          tester.widget<TextField>(field('End date')).controller!.text =
              '2026-10-30';
          await tester.drag(find.byType(ListView), const Offset(0, -400));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text('Choose Project site'));
          await tester.tap(find.text('Choose Project site'));
          await tester.pumpAndSettle();
        }
        await tester.drag(find.byType(ListView), const Offset(0, 800));
        await tester.pumpAndSettle();
        await tester.ensureVisible(field('Project name'));
        await tester.tap(field('Project name'));
        await tester.pump();
        final save = find.widgetWithText(
          FilledButton,
          editing ? 'Save planning' : 'Create Project',
        );
        await tester.tap(save);
        await tester.pumpAndSettle();
        expect(requests, 1);
        expect(find.text('Saving…'), findsOneWidget);
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Saving…'),
              )
              .onPressed,
          isNull,
        );
        completion.complete();
        await tester.pumpAndSettle();
        expect(saved?['id'], projectId);
        expect(find.text('Open'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'Project form validates dates and retains edited values after server failure',
    (tester) async {
      var requests = 0;
      final repo = repository((options, handler) {
        requests++;
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response<Object?>(
              requestOptions: options,
              statusCode: 422,
              data: {
                'errors': [
                  {
                    'code': 'VALIDATION_FAILED',
                    'message': 'Review the saved site.',
                  },
                ],
              },
            ),
          ),
        );
      });
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: ProjectEditor(
            repository: repo,
            project: projectFixture(),
            chooseLocation: () async => null,
          ),
        ),
      );
      tester.widget<TextField>(field('End date')).controller!.text =
          '2026-09-30';
      await tester.tap(find.text('Save planning'));
      await tester.pumpAndSettle();
      expect(requests, 0);
      expect(
        find.text('End date must be on or after the start date.'),
        findsOneWidget,
      );
      tester.widget<TextField>(field('End date')).controller!.text =
          '2026-10-30';
      await tester.tap(find.text('Save planning'));
      await tester.pumpAndSettle();
      expect(requests, 1);
      expect(find.text('Review the saved site.'), findsOneWidget);
      expect(
        tester.widget<TextField>(field('Project name')).controller!.text,
        'Renovation',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Project ranking uses balanced sliders and versioned save/reset on Project endpoints',
    (tester) async {
      var weights = {...defaults};
      var version = 0;
      var personalized = false;
      final writes = <String>[];
      final repo = repository((options, handler) {
        expect(options.path, startsWith('/buyers/project-ranking-preferences'));
        if (options.method != 'GET') {
          writes.add(options.path);
          final input = projectObject(options.data);
          expect(input['version'], version);
          version++;
          personalized = !options.path.endsWith('/reset');
          weights = personalized
              ? projectObject(
                  input['weights'],
                ).map((key, value) => MapEntry(key, projectInt(value)))
              : {...defaults};
          expect(weights.values.reduce((a, b) => a + b), 100);
        }
        respond(options, handler, {
          'weights': weights,
          'default_weights': defaults,
          'personalized': personalized,
          'version': version,
          'defaults_version': 0,
          'algorithm_version': 'fms.normalized-weighted-sum.v1',
        });
      });
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: ProjectRankingPreferencesScreen(repository: repo),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Total 100%'), findsOneWidget);
      await tester.tap(find.byTooltip('Increase Material match'));
      await tester.pump();
      await tester.tap(find.text('Save preferences'));
      await tester.pumpAndSettle();
      expect(weights['material_match'], 41);
      expect(find.text('Personalized ranking is active'), findsOneWidget);
      await tester.tap(find.text('Reset to Default'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Reset to Default'));
      await tester.pumpAndSettle();
      expect(weights, defaults);
      expect(version, 2);
      expect(writes.length, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Work Package material dialog validates quantity and cancels with keyboard safely',
    (tester) async {
      final repo = repository(
        (options, handler) => respond(options, handler, {
          'items': [
            {
              'id': projectId,
              'name': 'Cement',
              'code': 'CEMENT',
              'compatible_units': [
                {'id': locationId, 'code': 'BAG'},
              ],
            },
          ],
        }),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: WorkPackageEditor(
            repository: repo,
            project: projectFixture(),
            chooseLocation: () async => null,
          ),
        ),
      );
      await tester.tap(find.text('Materials'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Search materials'), 'cement');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cement'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Quantity'), '0');
      await tester.tap(find.text('Add material'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Use a quantity above zero'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'CSV import remains scrollable with large text and an open keyboard',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repo = repository(
        (options, handler) => respond(options, handler, {}),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(2),
              viewInsets: const EdgeInsets.only(bottom: 180),
            ),
            child: child!,
          ),
          home: WorkPackageEditor(
            repository: repo,
            project: projectFixture(),
            chooseLocation: () async => null,
          ),
        ),
      );
      await tester.tap(find.text('Materials'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Import CSV'),
        180,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Import CSV'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
