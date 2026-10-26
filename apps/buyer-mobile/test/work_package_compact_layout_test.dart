import 'typed_project_fixtures.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/bottom_action_bar.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/projects/material_edit_sheet.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph/features/projects/work_package_editor.dart';
import 'package:materyalph/features/projects/work_package_material_widgets.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

const projectId = '01995000-0000-7000-8000-000000000001';
const siteId = '01995000-0000-7000-8000-000000000002';
const pieceUnit = '01995000-0000-7000-8000-000000000003';
const steelId = '01995000-0000-7000-8000-0000000000a1';

const steel = {
  'id': steelId,
  'code': 'REROLLED_STEEL_BAR',
  'name': 'Rerolled steel bar',
  'category_id': '01995000-0000-7000-8000-0000000000b1',
  'category_name': 'Steel and Reinforcement',
  'regulated': true,
  'match_type': 'EXACT',
  'matched_text': 'rerolled steel bar',
  'similarity': 1,
  'compatible_units': [
    {'id': pieceUnit, 'code': 'PC', 'name': 'Piece', 'precision': 0},
  ],
  'attributes': [
    {
      'code': 'steel_grade',
      'label': 'Steel grade',
      'value_type': 'ENUM',
      'allowed_values': ['Grade 33', 'Grade 40', 'Grade 60'],
      'unit_code': '',
    },
    {
      'code': 'nominal_diameter_mm',
      'label': 'Nominal diameter or leg size',
      'value_type': 'NUMBER',
      'allowed_values': null,
      'unit_code': 'mm',
    },
    {
      'code': 'length_m',
      'label': 'Length',
      'value_type': 'NUMBER',
      'allowed_values': null,
      'unit_code': 'm',
    },
  ],
};

ProjectsRepository repository() {
  final client = api.MateryalphApiClient(
    dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.resolve(
          Response<Object?>(
            requestOptions: options,
            statusCode: 200,
            data: {
              'data': {
                'items': [steel],
                'units': steel['compatible_units'],
              },
              'meta': <String, Object?>{},
              'errors': <Object?>[],
            },
          ),
        ),
      ),
    ],
  );
  return ProjectsRepository(
    client: client,
    onSessionExpired: () async => fail('A form must not end the session'),
  );
}

Map<String, Object?> line(int i, {Map<String, Object?>? specs}) => {
  'material_id': steelId,
  'name': 'Rerolled steel bar',
  'unit_id': pieceUnit,
  'unit_code': 'PC',
  'quantity': '${50 + i}',
  'specifications': specs ?? <String, Object?>{},
};

Widget editor({int lines = 5, Map<String, Object?>? firstSpecs}) =>
    WorkPackageEditor(
      repository: repository(),
      project: typedProject({
        'id': projectId,
        'budget_centavos': 100000000,
        'budget': {'unallocated_centavos': 100000000},
        'sites': [
          {'id': siteId, 'name': '629 J Nepomuceno St'},
        ],
      }),
      package: typedPackage({
        'id': '01995000-0000-7000-8000-000000000010',
        'status': 'DRAFT',
        'lock_version': 1,
        'version': {
          'content': {
            'name': 'FOUNDATION',
            'site_id': siteId,
            'fulfillment_method': 'DELIVERY',
            'radius_km': 5,
            'lines': [
              for (var i = 0; i < lines; i++)
                line(i, specs: i == 0 ? firstSpecs : null),
            ],
          },
        },
      }),
      chooseLocation: () async => null,
    );

Future<void> pumpAt(
  WidgetTester tester,
  Size size,
  double scale,
  Widget page,
) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: BuyerTheme.light,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: page,
    ),
  );
  await tester.pumpAndSettle();
}

ScrollPosition scrollOf(WidgetTester tester, Finder list) => tester
    .state<ScrollableState>(
      find.descendant(of: list, matching: find.byType(Scrollable)).first,
    )
    .position;

void main() {
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

  for (final (size, scale) in [
    (const Size(360, 800), 1.0),
    (const Size(320, 640), 1.0),
    (const Size(360, 800), 1.3),
    (const Size(320, 640), 1.3),
  ]) {
    final label = '${size.width.toInt()}x${size.height.toInt()} @ ${scale}x';

    testWidgets(
      'main screen fits name and three rows without scrolling, $label',
      (tester) async {
        await pumpAt(tester, size, scale, editor());
        expect(tester.takeException(), isNull);
        final barTop = tester.getTopLeft(find.byType(BottomActionBar)).dy;
        expect(find.text('5 items'), findsOneWidget);
        expect(
          tester.getRect(find.text('Work Package name')).bottom,
          lessThan(barTop),
        );
        expect(
          tester.getRect(find.byType(CompactItemTile).at(2)).bottom,
          lessThanOrEqualTo(barTop),
        );
        await tester.scrollUntilVisible(
          find.text('Delivery · 629 J Nepomuceno St'),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('Site contact'), findsNothing);
        final page = scrollOf(tester, find.byType(Scaffold).first);
        // A lazy list only estimates its extent until every child is laid out.
        for (var i = 0; i < 4; i++) {
          page.jumpTo(page.maxScrollExtent);
          await tester.pump();
        }
        expect(
          page.maxScrollExtent,
          lessThanOrEqualTo(size.height),
          reason: 'at most one screen height of scrolling with five items',
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Edit Material shows choice, quantity, details and actions without scrolling, $label',
      (tester) async {
        await pumpAt(tester, size, scale, editor(lines: 1));
        await tester.tap(find.byTooltip('Edit quantity and details'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        // The sheet replaces the inline panel: no card content moved.
        expect(find.byType(MaterialEditSheet), findsOneWidget);
        final sheet = find.byType(MaterialEditSheet);
        Finder inSheet(Finder f) => find.descendant(of: sheet, matching: f);
        final save = inSheet(find.widgetWithText(FilledButton, 'Save changes'));
        final footerTop = tester.getRect(save).top;
        expect(tester.getRect(save).bottom, lessThanOrEqualTo(size.height));
        expect(inSheet(find.text('Cancel')), findsOneWidget);
        for (final visible in [
          find.text('Material name'),
          find.text('Change'),
          find.text('Pieces'),
          find.text('Unit'),
          find.text('Technical details'),
        ]) {
          expect(
            tester.getRect(inSheet(visible).first).bottom,
            lessThan(footerTop),
            reason: '$visible is visible without scrolling',
          );
        }
        final body = scrollOf(tester, sheet);
        expect(body.pixels, 0);

        // Expanded: at most about one sheet of scrolling, footer still pinned.
        await tester.tap(inSheet(find.text('Technical details')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(
          inSheet(find.text('Brand requirement (optional)')),
          findsOneWidget,
        );
        expect(
          body.maxScrollExtent,
          lessThanOrEqualTo(body.viewportDimension * 1.1),
        );
        expect(tester.getRect(save).top, footerTop);
      },
    );
  }

  testWidgets(
    'technical details auto-open when set and show a count when closed',
    (tester) async {
      await pumpAt(
        tester,
        const Size(360, 800),
        1,
        editor(lines: 1, firstSpecs: {'length_m': '6'}),
      );
      await tester.tap(find.byTooltip('Edit quantity and details'));
      await tester.pumpAndSettle();
      final length = find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Length (m)',
      );
      expect(tester.widget<TextField>(length).controller!.text, '6');
      expect(find.text('1 set'), findsNothing);
      await tester.tap(find.text('Technical details'));
      await tester.pumpAndSettle();
      expect(length, findsNothing);
      expect(find.text('1 set'), findsOneWidget);
    },
  );

  testWidgets('revising a line in the sheet replaces it and keeps the list', (
    tester,
  ) async {
    await pumpAt(tester, const Size(360, 800), 1, editor(lines: 2));
    await tester.tap(find.byTooltip('Edit quantity and details').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Pieces',
      ),
      '75',
    );
    await tester.tap(find.text('Change'));
    await tester.pumpAndSettle();
    expect(find.text('Exact name'), findsOneWidget);
    await tester.tap(find.text('Rerolled steel bar').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save changes'));
    await tester.pumpAndSettle();
    expect(find.byType(MaterialEditSheet), findsNothing);
    expect(find.textContaining('75 PC'), findsOneWidget);
    expect(find.textContaining('51 PC'), findsOneWidget);
    expect(find.text('2 items'), findsOneWidget);
  });

  testWidgets(
    'Finalize opens site and fulfillment when delivery details are missing',
    (tester) async {
      await pumpAt(tester, const Size(360, 800), 1, editor(lines: 1));
      await tester.enterText(
        find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.labelText == 'Budget',
        ),
        '1000',
      );
      await tester.tap(find.text('Finalize'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Add a site contact'), findsOneWidget);
      expect(find.text('Site contact'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('package description is collapsed until requested', (
    tester,
  ) async {
    await pumpAt(tester, const Size(360, 800), 1, editor(lines: 1));
    expect(find.text('Package description (optional)'), findsNothing);
    await tester.tap(find.text('Add description (optional)'));
    await tester.pumpAndSettle();
    expect(find.text('Package description (optional)'), findsOneWidget);
    // Focused: the counter appears.
    expect(find.text('0/2000'), findsOneWidget);
  });
}
