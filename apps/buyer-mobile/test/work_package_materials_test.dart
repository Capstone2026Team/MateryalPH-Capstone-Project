import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/design_system/compact_density.dart';
import 'package:materyalph/features/projects/material_search_results.dart';
import 'package:materyalph/features/projects/work_package_estimate_widgets.dart';
import 'package:materyalph/features/projects/work_package_material_widgets.dart';

Widget host(Widget child) => MaterialApp(
  theme: BuyerTheme.light,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

const cement = {
  'id': '01995000-0000-7000-8000-0000000000c1',
  'name': 'Portland cement',
  'category_name': 'Cement and Concrete',
  'regulated': true,
  'match_type': 'EXACT',
  'matched_text': 'Portland cement',
  'similarity': 1.0,
};
const blended = {
  'id': '01995000-0000-7000-8000-0000000000c2',
  'name': 'Blended cement',
  'category_name': 'Cement and Concrete',
  'regulated': true,
  'match_type': 'FUZZY',
  'matched_text': 'blended cement',
  'similarity': 0.41,
};

void main() {
  test('quantity and detail labels read naturally', () {
    expect(materialQuantity('25.0000'), '25');
    expect(materialQuantity('2.5000'), '2.5');
    expect(materialQuantity('100'), '100');
    expect(materialQuantity(null), '');
    expect(detailLabel('thickness_mm'), 'Thickness mm');
  });

  testWidgets('available budget shows what remains and blocks overspending', (
    tester,
  ) async {
    final controller = TextEditingController(text: '600,000.00');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      host(
        ProjectReserveHint(
          controller: controller,
          reserveCentavos: 50000000,
          projectCentavos: 100000000,
        ),
      ),
    );
    expect(find.text('₱500,000.00 of ₱1,000,000.00'), findsOneWidget);
    expect(
      find.text(
        '₱100,000.00 more than the available Project budget. Lower it to save.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Use all'));
    await tester.pump();
    expect(controller.text, '500,000.00');
    expect(find.text('Remaining after this package: ₱0.00'), findsOneWidget);
    expect(find.text('Use all'), findsNothing);
  });

  testWidgets('compact item row summarises the line on one subtitle line', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var edited = 0, removed = 0;
    await tester.pumpWidget(
      host(
        CompactItemTile(
          index: 0,
          line: const {
            'material_id': null,
            'name': 'Washed sand S-1',
            'quantity': '62.5000',
            'unit_code': 'CUM',
            'preferred_brand': null,
            'color': 'Grey',
            'description': 'For plastering',
            'specifications': {'size': 'S-1'},
          },
          onEdit: () => edited++,
          onRemove: () => removed++,
        ),
      ),
    );
    expect(
      find.text('62.5 CUM · Any brand · Color: Grey · Size: S-1'),
      findsOneWidget,
    );
    expect(find.text('Unlisted'), findsOneWidget);
    // The description is not shown in the row but is still announced.
    expect(find.text('For plastering'), findsNothing);
    expect(
      find.bySemanticsLabel(RegExp('Washed sand S-1.*For plastering')),
      findsOneWidget,
    );
    expect(
      tester.getSize(find.byType(CompactItemTile)).height,
      inInclusiveRange(64, 72),
    );
    await tester.tap(find.byTooltip('Edit quantity and details'));
    await tester.tap(find.byTooltip('Remove material'));
    expect([edited, removed], [1, 1]);
    semantics.dispose();
  });

  testWidgets('counters appear only when focused or near the limit', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      host(
        TextField(
          controller: controller,
          maxLength: 10,
          buildCounter: nearLimitCounter,
        ),
      ),
    );
    expect(find.text('0/10'), findsNothing);
    controller.text = '12345678';
    await tester.pump();
    expect(find.text('8/10'), findsOneWidget);
    controller.text = '1';
    await tester.pump();
    expect(find.text('1/10'), findsNothing);
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(find.text('1/10'), findsOneWidget);
  });

  testWidgets('search results cap at three and explain unlisted when chosen', (
    tester,
  ) async {
    final many = [
      for (var i = 0; i < 5; i++)
        {...cement, 'id': 'id-$i', 'name': 'Cement $i'},
    ];
    var unlisted = false;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, update) => MaterialSearchResults(
            matches: many,
            searching: false,
            query: 'cement',
            selectedId: null,
            unlisted: unlisted,
            onChoose: (m) => update(() => unlisted = m == null),
          ),
        ),
      ),
    );
    expect(
      find.textContaining(RegExp(r'^Cement \d$')),
      findsNWidgets(maxVisibleMatches),
    );
    expect(find.textContaining('never matched automatically'), findsNothing);
    await tester.tap(find.text('Not listed — use “cement”'));
    await tester.pump();
    expect(find.textContaining('never matched automatically'), findsOneWidget);
  });

  testWidgets('match list labels exact and close matches and offers unlisted', (
    tester,
  ) async {
    Object? picked = 'none';
    await tester.pumpWidget(
      host(
        MaterialSearchResults(
          matches: const [cement, blended],
          searching: false,
          query: 'cement',
          selectedId: cement['id'] as String,
          unlisted: false,
          onChoose: (m) => picked = m,
        ),
      ),
    );
    expect(find.text('Exact name'), findsOneWidget);
    expect(find.text('Close match 41%'), findsOneWidget);
    expect(
      find.textContaining('Confirm it is the same product'),
      findsOneWidget,
    );
    expect(find.text('DTI-BPS regulated'), findsNWidgets(2));
    await tester.tap(find.text('Not listed — use “cement”'));
    expect(picked, isNull);
    await tester.tap(find.text('Blended cement'));
    expect((picked as Map?)?['name'], 'Blended cement');
  });

  testWidgets('estimate shows total, budget fit, reminder and line breakdown', (
    tester,
  ) async {
    int? used;
    await tester.pumpWidget(
      host(
        WorkPackageEstimateSection(
          lines: const [
            {'name': 'Portland cement', 'quantity': '10', 'unit_code': 'BAG'},
            {'name': 'River sand', 'quantity': '2', 'unit_code': 'CUM'},
          ],
          estimate: const {
            'materials_total_centavos': 220000,
            'priced_line_count': 1,
            'radius_km': 5,
            'lines': [
              {
                'index': 0,
                'status': 'PRICED',
                'average_unit_price_centavos': 22000,
                'amount_centavos': 220000,
              },
              {'index': 1, 'status': 'UNLISTED'},
            ],
          },
          loading: false,
          error: null,
          budgetCentavos: 200000,
          ready: true,
          onRetry: () {},
          onUseAsBudget: (total) => used = total,
        ),
      ),
    );
    expect(find.text('₱2,200.00'), findsWidgets);
    expect(find.text('Over your budget by ₱200.00'), findsOneWidget);
    expect(
      find.textContaining('excludes delivery fees and labor'),
      findsOneWidget,
    );
    expect(find.text('10 BAG × ₱220.00'), findsOneWidget);
    expect(find.text('2 CUM · unlisted, not priced'), findsOneWidget);
    await tester.tap(find.text('Use estimate as budget'));
    expect(used, 220000);
  });

  testWidgets('empty state explains what to do', (tester) async {
    await tester.pumpWidget(host(const MaterialsEmptyState()));
    expect(find.text('No materials yet'), findsOneWidget);
  });
}
