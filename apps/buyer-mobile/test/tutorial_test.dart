import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/guided_walkthrough.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/tutorial/tutorial_repository.dart';
import 'package:materyalph/screens/buyer_home_screen.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

class MemoryTutorials implements TutorialRepository {
  final progress = <String, String>{};
  bool fail = false;
  @override
  Future<Map<String, String>> load() async => Map.of(progress);
  @override
  Future<void> acknowledge(String key, bool completed) async {
    if (fail) throw StateError('offline');
    progress[key] = completed ? 'COMPLETED' : 'SKIPPED';
  }
}

void main() {
  setUpAll(() async {
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'))).load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  testWidgets(
    'a first visit opens once, Skip persists, and another account has its own tour',
    (tester) async {
      final repository = MemoryTutorials();
      Widget home(String user, MemoryTutorials repo) => MaterialApp(
        theme: BuyerTheme.light,
        home: BuyerHomeScreen(
          key: ValueKey(user),
          tutorialRepository: repo,
          onSignOut: () async {},
        ),
      );
      await tester.pumpWidget(home('first', repository));
      await tester.pumpAndSettle();
      expect(find.text('Find suppliers near your site'), findsOneWidget);
      await tester.ensureVisible(find.text('Skip'));
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(repository.progress['overview'], 'SKIPPED');
      await tester.pumpWidget(home('first-relogin', repository));
      await tester.pumpAndSettle();
      expect(find.text('Find suppliers near your site'), findsNothing);
      await tester.pumpWidget(home('second', MemoryTutorials()));
      await tester.pumpAndSettle();
      expect(find.text('Find suppliers near your site'), findsOneWidget);
      await tester.tap(find.byTooltip('Close tutorial'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'failed progress saves leave the app usable and expose an explicit retry',
    (tester) async {
      final repository = MemoryTutorials()..fail = true;
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: BuyerHomeScreen(
            tutorialRepository: repository,
            onSignOut: () async {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Skip'));
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(find.text('Tutorial progress is not saved.'), findsOneWidget);
      expect(find.text('Find suppliers near your site'), findsNothing);
      expect(repository.progress, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  for (final size in [const Size(320, 568), const Size(844, 390)]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'spotlight, Back and Finish reflow at $size with text scale $scale',
        (tester) async {
          await tester.binding.setSurfaceSize(size);
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(() {
            tester.platformDispatcher.clearTextScaleFactorTestValue();
            return tester.binding.setSurfaceSize(null);
          });
          final target = GlobalKey();
          final previousShadows = debugDisableShadows;
          debugDisableShadows = false;
          addTearDown(() => debugDisableShadows = previousShadows);
          final capture = GlobalKey();
          bool? result;
          final destinations = <int>[];
          await tester.pumpWidget(
            RepaintBoundary(
              key: capture,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: BuyerTheme.light,
                home: Builder(
                  builder: (context) => Scaffold(
                    body: const Center(child: Text('Your materials workspace')),
                    bottomNavigationBar: SizedBox(
                      key: target,
                      height: 76,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                result = await showGuidedWalkthrough(
                                  context,
                                  steps: [
                                    WalkthroughStep(
                                      target: target,
                                      title: 'Find suppliers near your site',
                                      description:
                                          'Choose a location and radius, then open a supplier pin or use the supplier list.',
                                      icon: Icons.map_outlined,
                                      destination: 0,
                                    ),
                                    WalkthroughStep(
                                      target: target,
                                      title: 'Compare your materials',
                                      description:
                                          'Review specifications and prices before adding materials to your cart.',
                                      icon: Icons.inventory_2_outlined,
                                      destination: 1,
                                    ),
                                  ],
                                  selectDestination: destinations.add,
                                );
                              },
                              child: const Text('Start tour'),
                            ),
                          ),
                          const Expanded(child: Center(child: Text('Explore'))),
                          const Expanded(child: Center(child: Text('Profile'))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.tap(find.text('Start tour'));
          await tester.pumpAndSettle();
          expect(
            tester
                .widget<OutlinedButton>(
                  find.widgetWithText(OutlinedButton, 'Back'),
                )
                .onPressed,
            isNull,
          );
          final preview = Platform.environment['TUTORIAL_PREVIEW_DIR'];
          if (preview != null && scale == 1 && size.width == 320) {
            await tester.runAsync(() async {
              final boundary =
                  capture.currentContext!.findRenderObject()!
                      as RenderRepaintBoundary;
              final image = await boundary.toImage(pixelRatio: 2);
              final bytes = await image.toByteData(
                format: ui.ImageByteFormat.png,
              );
              await Directory(preview).create(recursive: true);
              await File(
                '$preview/buyer-tutorial.png',
              ).writeAsBytes(bytes!.buffer.asUint8List());
              image.dispose();
            });
          }
          await tester.ensureVisible(find.text('Next'));
          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();
          expect(find.text('Compare your materials'), findsOneWidget);
          await tester.ensureVisible(find.text('Back'));
          await tester.tap(find.text('Back'));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text('Next'));
          await tester.tap(find.text('Next'));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text('Finish'));
          await tester.tap(find.text('Finish'));
          await tester.pumpAndSettle();
          expect(result, isTrue);
          expect(destinations, [0, 1, 0, 1]);
          debugDisableShadows = previousShadows;
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  test(
    'generated client persists the signed-in Buyer scope and maps progress',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1'));
      final writes = <RequestOptions>[];
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.method == 'PUT') writes.add(options);
            handler.resolve(
              Response(
                requestOptions: options,
                data: {
                  'data': [
                    {
                      'tutorial_key': 'overview',
                      'status': 'SKIPPED',
                      'updated_at': '2026-11-10T00:00:00Z',
                    },
                  ],
                  'meta': <String, dynamic>{},
                  'errors': <dynamic>[],
                },
              ),
            );
          },
        ),
      );
      final repository = ApiTutorialRepository(
        api.MateryalphApiClient(dio: dio),
        () async {},
      );
      expect(await repository.load(), {'overview': 'SKIPPED'});
      await repository.acknowledge('projects', true);
      expect(writes.single.path, '/buyers/account/tutorials/projects');
      expect(writes.single.data, {'status': 'COMPLETED'});
    },
  );
}
