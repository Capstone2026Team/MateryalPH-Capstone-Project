import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/projects/material_edit_sheet.dart';
import 'package:materyalph/features/projects/projects_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

const cubicMeter = '01995000-0000-7000-8000-000000000003';
const concreteId = '01995000-0000-7000-8000-0000000000a2';

const concrete = {
  'id': concreteId,
  'code': 'READY_MIXED_CONCRETE',
  'name': 'Ready-mixed concrete',
  'category_id': '01995000-0000-7000-8000-0000000000b2',
  'category_name': 'Ready-Mixed Concrete',
  'regulated': false,
  'match_type': 'EXACT',
  'matched_text': 'ready-mixed concrete',
  'similarity': 1,
  'compatible_units': [
    {'id': cubicMeter, 'code': 'CUM', 'name': 'Cubic meter', 'precision': 4},
  ],
  'attributes': <Object?>[],
};

ProjectsRepository repository() => ProjectsRepository(
  client: api.MateryalphApiClient(
    dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.resolve(
          Response<Object?>(
            requestOptions: options,
            statusCode: 200,
            data: {
              'data': {
                'items': [concrete],
                'units': concrete['compatible_units'],
              },
              'meta': <String, Object?>{},
              'errors': <Object?>[],
            },
          ),
        ),
      ),
    ],
  ),
  onSessionExpired: () async => fail('A form must not end the session'),
);

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

  Finder field(String label) => find.byWidgetPredicate(
    (w) => w is TextField && w.decoration?.labelText == label,
  );

  Future<void> openSheet(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        home: Scaffold(
          body: MaterialEditSheet(
            repository: repository(),
            initial: const {
              'material_id': concreteId,
              'name': 'Ready-mixed concrete',
              'unit_id': cubicMeter,
              'unit_code': 'CUM',
              'quantity': '1',
              'specifications': <String, Object?>{},
            },
            onSubmit: (_) {},
            onCancel: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Ready-Mixed Concrete is asked as an Order volume (m³)', (
    tester,
  ) async {
    await openSheet(tester);
    expect(field('Order volume (m³)'), findsOneWidget);
    expect(field('Quantity'), findsNothing);
    expect(
      find.text('Cubic meters of concrete to deliver to your site.'),
      findsOneWidget,
    );
    expect(find.text('Units this material is sold in.'), findsNothing);
  });

  testWidgets('an invalid Order volume is named in the error', (tester) async {
    await openSheet(tester);
    await tester.enterText(field('Order volume (m³)'), '0');
    await tester.tap(find.widgetWithText(FilledButton, 'Save changes'));
    await tester.pumpAndSettle();
    expect(
      find.text('Use an order volume above zero, up to 1,000,000 m³.'),
      findsOneWidget,
    );
  });
}
