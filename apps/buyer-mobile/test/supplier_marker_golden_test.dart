import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/map_geometry.dart';
import 'package:materyalph/features/map_discovery/supplier_map.dart';

SupplierResultView supplier(
  String id,
  SupplierTier tier, {
  bool favorite = false,
}) => SupplierResultView(
  resultId: id,
  tier: tier,
  rank: 1,
  name: 'Hardware',
  point: const GeoPoint(14.6, 121),
  distanceMeters: 0,
  scoreKind: ScoreKind.directory,
  scoreText: 'Directory',
  isFavorite: favorite,
);

void main() {
  testWidgets(
    'tier, favorite, selected and segmented cluster markers have distinct glyphs',
    (tester) async {
      final vendor = supplier('vendor', SupplierTier.verified);
      final directory = supplier('directory', SupplierTier.directory);
      final favorite = supplier(
        'favorite',
        SupplierTier.verified,
        favorite: true,
      );
      final composed = await tester.runAsync(() async {
        await (FontLoader(
          'Inter',
        )..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'))).load();
        final images = await Future.wait([
          paintSupplierMarker(
            vendor,
            selected: false,
            showLabel: false,
            ratio: 2,
          ),
          paintSupplierMarker(
            directory,
            selected: false,
            showLabel: false,
            ratio: 2,
          ),
          paintSupplierMarker(
            favorite,
            selected: false,
            showLabel: false,
            ratio: 2,
          ),
          paintSupplierMarker(
            favorite,
            selected: true,
            showLabel: false,
            ratio: 2,
          ),
          paintClusterMarker(MapGroup([vendor, directory, favorite]), 2),
        ]);
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder)..drawColor(Colors.white, BlendMode.src);
        for (var i = 0; i < images.length; i++) {
          final codec = await ui.instantiateImageCodec(images[i]);
          final frame = await codec.getNextFrame();
          final image = frame.image;
          canvas.drawImage(
            image,
            Offset(18 + i * 132.0, (160 - image.height) / 2),
            Paint(),
          );
          image.dispose();
          codec.dispose();
        }
        final picture = recorder.endRecording();
        final image = await picture.toImage(680, 160);
        picture.dispose();
        return image;
      });
      await expectLater(
        composed!,
        matchesGoldenFile('goldens/supplier-markers.png'),
      );
      composed.dispose();
    },
  );
}
