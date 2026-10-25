import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/procurement_components.dart';
import 'package:materyalph/design_system/theme.dart';

void main() {
  const labels = ['7 days', '30 days', '90 days', 'Custom'];

  Future<int?> pump(WidgetTester tester, double width, double scale) async {
    int? chosen;
    tester.view.physicalSize = Size(width * 2, 1200);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(width, 600),
            textScaler: TextScaler.linear(scale),
          ),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: StatefulBuilder(
                builder: (context, setState) => SegmentedTabs(
                  labels: labels,
                  selected: chosen ?? 1,
                  onChanged: (index) => setState(() => chosen = index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return chosen;
  }

  Set<double> rows(WidgetTester tester) => {
    for (final label in labels) tester.getTopLeft(find.text(label)).dy,
  };

  // The test font draws every glyph a full em wide, so "fits" needs more room than real fonts.
  testWidgets('one row when every label fits', (tester) async {
    await pump(tester, 600, 1);
    expect(find.byType(Wrap), findsNothing);
    expect(rows(tester), hasLength(1));
  });

  testWidgets('wraps whole tabs instead of breaking words at 2x text', (
    tester,
  ) async {
    await pump(tester, 320, 2);
    expect(find.byType(Wrap), findsOneWidget);
    expect(rows(tester).length, greaterThan(1));
    // Every word of every label fits on one line of its tab.
    for (final label in labels) {
      final paragraph = tester.renderObject<RenderParagraph>(find.text(label));
      var start = 0;
      for (final word in label.split(' ')) {
        // A word split across lines selects as more than one box.
        final boxes = paragraph.getBoxesForSelection(
          TextSelection(baseOffset: start, extentOffset: start + word.length),
        );
        expect(boxes, hasLength(1), reason: '"$word" broke across lines');
        start += word.length + 1;
      }
    }
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Custom'));
    await tester.pump();
    expect(
      tester
          .widget<Semantics>(
            find.ancestor(
              of: find.text('Custom'),
              matching: find.byWidgetPredicate(
                (w) => w is Semantics && w.properties.selected != null,
              ),
            ),
          )
          .properties
          .selected,
      isTrue,
    );
  });
}
